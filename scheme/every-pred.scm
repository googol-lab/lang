(define (my-every-pred . args)
  (define (iter x preds)
    (or (null? preds)
	(if ((car preds) x)
	    (iter x (cdr preds))
	    #f)))
  (lambda (x) (iter x args)))
