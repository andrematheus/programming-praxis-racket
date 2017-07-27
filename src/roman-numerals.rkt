#lang racket

;; Roman numerals are a number-notation system developed in classical
;; Rome, chiefly used today to indicate the year in which a motion
;; picture was made, or the sequence number of a Super Bowl.

;; Roman numerals use letters of the alphabet to indicate numerical
;; value, according to the following code:

;;     I 1 V 5 X 10 L 50 C 100 D 500 M 1000

;; For example, the number 1732 is represented by Roman numerals as
;; MDCCXXXII, and the number 1956 is represented by Roman numerals as
;; MDCCCCLVI. Letter symbols are normally written from the largest symbol
;; to the smallest, left to right, so the numeric values are
;; additive. However, in order to conserve space, it is permissible to
;; replace four of the same symbol written all in a row in a subtractive
;; manner to the left of a higher-value symbol, so that 1956 may also be
;; represented as MCMLVI, where the CM symbol, with C before M, indicates
;; that C is subtracted from M, and thus indicates the numeric value
;; 900. Wikipedia and MathWorld explain the common usage of Roman
;; numerals.

;; Your task is to write a function that takes two roman numerals
;; (character strings) as input and returns their sum as a roman numeral
;; as output. Be sure that input can be given in either the additive or
;; subtractive forms of Roman numerals; give output using the subtractive
;; form. What is add-roman("CCCLXIX", "CDXLVIII")?

(module+ test
  (require rackunit))
