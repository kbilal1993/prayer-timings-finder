#!/bin/env racket
#lang racket
(require racket/date)
(require net/http-client)
(require json)

;prayertimes.rkt
;Uses aladhan's calendar by city api to find today's prayer times

;Options. You'll probably want to edit this
;See aladhan.com/prayer-times-api for explanations
(define options
  '((country . "UnitedKingdom")
    (city    . "London")
    (method  . "2")
    (school  . "1"))) ; 1 for Hanafi, 0 for anything else

;Don't edit beyond this point unless you know what you're doing
(define (get-date)
  (let ((d (current-date)))
    `((day   . ,(number->string (date-day d)))
      (month . ,(number->string (date-month d)))
      (year  . ,(number->string (date-year d))))))

(define (make-uri-string o d)
  (string-append "/v1/calendarByCity?"
               (string-join
                (list (string-join `("city"    ,(cdr (assoc 'city o))) "=")
                      (string-join `("country" ,(cdr (assoc 'country o))) "=")
                      (string-join `("method"  ,(cdr (assoc 'method o))) "=")
                      (string-join `("month"   ,(cdr (assoc 'month d))) "=")
                      (string-join `("year"    ,(cdr (assoc 'year d))) "="))
                "&")))

(define (query-aladhan)
  (http-sendrecv
   "api.aladhan.com"
   (make-uri-string options (get-date))))

(define (get-prayer-times-json)
  (let-values (((status headers in) (query-aladhan)))
    (string->jsexpr (port->string in))))

(define (get-prayer-times)
  (let ((data 
         ((compose1
           (lambda (x) (hash-ref x 'timings))
           (lambda (x) (list-ref x (sub1 (string->number (cdr (assoc 'day (get-date)))))))
           (lambda (x) (hash-ref x 'data))
           get-prayer-times-json))))
    `((fajr    . ,(car (string-split (hash-ref data 'Fajr))))
      (sunrise . ,(car (string-split (hash-ref data 'Sunrise))))
      (zuhr    . ,(car (string-split (hash-ref data 'Dhuhr))))
      (asr     . ,(car (string-split (hash-ref data 'Asr))))
      (maghrib . ,(car (string-split (hash-ref data 'Maghrib))))
      (isha    . ,(car (string-split (hash-ref data 'Isha)))))))
   
(define (print-times)
  (for ((x (get-prayer-times)))
    (printf "~a\t~a\n" (car x) (cdr x))))

;main
(print-times)
