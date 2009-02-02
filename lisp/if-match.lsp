(defmacro dbind (pat seq &body body)
  (let ((gseq (gensym)))
    `(let ((,gseq ,seq))
       ,(dbind-ex (destruc pat gseq #'atom) body))))

(defun destruc (pat seq &optional (atom? #'atom) (n 0)) 
  (if (null pat)
      nil
    (let ((rest (cond ((funcall atom? pat) pat)
		      ((eq (car pat) '&rest) (cadr pat))
		      ((eq (car pat) '&body) (cadr pat))
		      (t nil))))
      (if rest
	  `((,rest (subseq ,seq ,n)))
	(let ((p (car pat))
	      (rec (destruc (cdr pat) seq atom? (1+ n))))
	  (if (funcall atom? p)
	      (cons `(,p (elt ,seq ,n))
		    rec)
	    (let ((var (gensym)))
	      (cons (cons `(,var (elt ,seq ,n))
			  (destruc p var atom?))
		    rec))))))))

(defun dbind-ex (binds body)
  (if (null binds)
      `(progn ,@body)
    `(let ,(mapcar #'(lambda (b)
		       (if (consp (car b))
			   (car b)
			 b))
		   binds)
       ,(dbind-ex (mapcan #'(lambda (b)
			      (if (consp (car b))
				  (cdr b)))
			  binds)
		  body))))

(defmacro our-with-gensyms (syms &body body)
  `(let ,(mapcar #'(lambda (s)
		     `(,s (gensym)))
		 syms)
     ,@body))

(defmacro if-match (pat seq then &optional else)
  `(let ,(mapcar #'(lambda (v) `(,v ',(gensym)))
		 (vars-in pat #'simple?))
     (pat-match ,pat ,seq ,then ,else)))

(defun vars-in (expr &optional (atom? #'atom))
  (if (funcall atom? expr)
      (if (var? expr) (list expr))
    (union (vars-in (car expr) atom?)
	   (vars-in (cdr expr) atom?))))

(defun var? (x)
  (and (symbolp x) (eq (char (symbol-name x) 0) #\?)))

(defmacro pat-match (pat seq then else)
  (if (simple? pat)
      (match1 `((,pat ,seq)) then else)
    (our-with-gensyms (gseq gelse)
		  `(labels ((,gelse () ,else))
		     ,(gen-match (cons (list gseq seq)
				       (destruc pat gseq #'simple?))
				 then
				 `(,gelse))))))

(defun simple? (x) (or (atom x) (eq (car x) 'quote)))

(defun gen-match (refs then else)
  (if (null refs)
      then
    (let ((then (gen-match (cdr refs) then else)))
      (if (simple? (caar refs))
	  (match1 refs then else)
	(gen-match (car refs) then else)))))


(defun match1 (refs then else)
  (dbind ((pat expr) . rest) refs
	 (cond ((gensym? pat)
		`(let ((,pat ,expr))
		   (if (and (typep ,pat 'sequence)
			    ,(length-test pat rest))
		       ,then
		     ,else)))
	       ((eq pat '_) then)
	       ((var? pat)
		(let ((ge (gensym)))
		  `(let ((,ge ,expr))
		     (if (or (gensym? ,pat) (equal ,pat ,ge))
			 (let ((,pat ,ge)) ,then)
		       ,else))))
	       (t `(if (equal ,pat ,expr) ,then ,else)))))

(defun gensym? (s)
  (and (symbolp s) (not (symbol-package s))))

(defun length-test (pat rest)
  (let ((fin (caadar (last rest))))
    (if (or (consp fin) (eq fin 'elt))
	`(= (length ,pat) ,(length rest))
      `(> (length ,pat) ,(- (length rest) 2)))))
