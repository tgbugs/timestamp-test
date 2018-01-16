#lang racket/base
(require racket/list
         racket/string
         racket/system)

(define now (current-seconds))
(define template "https://github.com/tgbugs/timestamp-test/blob/master@{~a}/test-file")
(define (update-file)
  (write-string (string-join (for/list ([i (range 100)]) (format template (+ now i))) "\n")))
(with-output-to-file "test-file" #:exists 'replace update-file)
(define command (format
                 "date +%s && git add -u && git commit --date ~a-0800 -m 'test commit' && date +%s"
                 now))
(system command)
