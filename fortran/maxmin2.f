*     SAIDAICHI (DATA NO KOSU = N)
      INTEGER A(1:100), KOSU,MAXV

      OPEN(10,FILE='AI.TXT', STATUS='OLD')
      READ(10,100) KOSU
 100  FORMAT(I4)
      READ(10,110) (A(I),I=1,KOSU)
 110  FORMAT(5I10)
      CLOSE(10)

      MAXV=A(1)
      DO 10 I=2,KOSU
         IF(A(I).GT.MAXV) MAXV=A(I)
 10   CONTINUE
      WRITE(6,*) MAXV
      END
