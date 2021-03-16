#lang racket
(define calc
  (lambda (exp)
    (match exp                                ; 匹配表达式的两种情况
      [(? number? x) x]                       ; 是数字，直接返回
      [`(,op ,e1 ,e2)                         ; 匹配并且提取出操作符 op 和两个操作数 e1, e2
       (let ([v1 (calc e1)]                   ; 递归调用 calc 自己，得到 e1 的值
             [v2 (calc e2)])                  ; 递归调用 calc 自己，得到 e2 的值
         (match op                            ; 分支：处理操作符 op 的 4 种情况
           ['+ (+ v1 v2)]                     ; 如果是加号，输出结果为 (+ v1 v2)
           ['- (- v1 v2)]                     ; 如果是减号，乘号，除号，相似的处理
           ['* (* v1 v2)]
           ['/ (/ v1 v2)]))])))

(calc '(+ 1 2))