#lang racket

;; February 19, 2009

;; Implement an RPN calculator that takes an expression like 19 2.14 +
;; 4.5 2 4.3 / - * which is usually expressed as (19 + 2.14) * (4.5 - 2 /
;; 4.3) and responds with 85.2974. The program should read expressions
;; from standard input and print the top of the stack to standard output
;; when a newline is encountered. The program should retain the state of
;; the operand stack between expressions.

(module+ test
  (require rackunit))

(define stack-append cons)

(define operators (make-hash))

(define-syntax-rule (define-operator (name stack-arg) body more-body ...)
  (hash-set! operators name (lambda (stack-arg) body more-body ...)))

(module+ test
  (test-begin
   (define-operator ("name" s) #t)
   (define operator (hash-ref operators "name"))

   (test-case
    "A defined operator must be avaiable as a function in the operators hash"
    (check-true (procedure? operator)))

   (test-case
    "The body passed to the operator must be evaluated and returned"
    (check-true (operator #f)))))

(define-syntax-rule (define-binary-operator (name op1 op2) body ...)
  (define-operator (name s)
    (define (op op1 op2) body ...)
    (let ([result (apply op (reverse (take s 2)))])
      (cons result (drop s 2)))))

(module+ test
  (test-begin
   (define operator-name "name")
   (define-binary-operator (operator-name x y) (list x y))
   (define operator (hash-ref operators operator-name))
   (test-case
    "A defined binary operator must be available as a function in the operators hash"
    (check-true (procedure? operator)))
   (test-case
    "A binary operator drops two items from the stack, and pushes its result on the stack"
    (let* ([stack (list 'a 'b)]
           [stack (operator stack)])
      (check-equal? (list 'b 'a) (first stack))))))

(for ([opinfo `(("+" ,+) ("-" ,-) ("*" ,*) ("/" ,/))])
  (define-binary-operator ((first opinfo) op1 op2)
    ((second opinfo) op1 op2)))

(define (rpn-evaluate-token stack token)
  (cond
    ((hash-has-key? operators token)
     ((hash-ref operators token) stack))
    ((string->number token)
     (stack-append (string->number token) stack))
    (#t (error (format "Invalid token: ~a" token)))))

(define (rpn-evaluate-line line stack)
  (if (string=? line "")
      (begin
        (displayln (first stack))
        stack)
      (let loop ([stack stack]
                 [tokens (string-split line)])
        (if (empty? tokens)
            stack
            (loop (rpn-evaluate-token stack (first tokens)) (rest tokens))))))

(define (rpn-calculator-repl-loop)
  (define (rpn-loop stack)
    (let ([line (read-line)])
      (if (eof-object? line)
          stack
          (rpn-loop (rpn-evaluate-line line stack)))))
  (rpn-loop '()))

(module+ main
  (command-line
   #:program "rpn-calculator"
   #:args to-calculate
   (let ([result (if (not (empty? to-calculate))
                     (rpn-evaluate-line (apply string-join to-calculate))
                     (rpn-calculator-repl-loop))])
     (when (not (empty? result))
       (displayln (first result))))))
