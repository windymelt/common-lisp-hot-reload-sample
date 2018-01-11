(in-package :cl-user)
(defpackage hot-reload-sample
  (:use :cl)
  (:export :main))
(in-package :hot-reload-sample)

(format t "loading...~%")

;;; 外部からここが呼び出される．
(defun main (&rest argv)
  (declare (ignorable argv))
  ;; clackを使ってHTTPサーバを起動する．
  (clack:clackup
   (lambda (env)
     (declare (ignorable env))
     ;; 常に200を返す．bodyは関数の戻り値にする．
     `(200 (:content-type "text/plain") (,(get-message)))))
  (format t "Press enter key to exit...~%")
  (read-line nil nil))

;;; HTTPレスポンスに乗るメッセージを返すための関数．
(defun get-message () "Hello, Clack!")

;;; Common Lispコード内部からでもホットリロードできるようにするための関数．
;;; 今回は使わない．
(defun reload ()
  (uiop:run-program (format nil "kill -HUP ~a" (getpid))))

;;; シグナルハンドラを定義するためのマクロ．
;;; from https://rosettacode.org/wiki/Handle_a_signal#Common_Lisp
(defmacro set-signal-handler (signo &body body)
  (let ((handler (gensym "HANDLER")))
    `(progn
       (cffi:defcallback ,handler :void ((signo :int))
         (declare (ignore signo))
         ,@body)
       (cffi:foreign-funcall "signal" :int ,signo :pointer (cffi:callback ,handler)))))

;;; リロード中にリロードが発生しないようにするためのフラグ．
(defvar *reloading* nil)
;;; SIGHUP(1)に対応するハンドラを作成する．
(set-signal-handler 1 ; 1 corresponds to SIGHUP
                    (unless *reloading*
                      (format t "SIGHUP received. Reloading...~&")
                      (setf *reloading* t)
                      ;; system名を指定することでreloadできる．
                      (asdf:load-system :hot-reload-sample)
                      (setf *reloading* nil)
                      (format t "Reload done.~%")))

;;; このコードを実行しているプロセスのPIDを返す関数．
;;; from KMRCL
;;; cf. http://g000001.cddddr.org/1279896483
(defun getpid ()
  "Return the PID of the lisp process."
  #+allegro (excl::getpid)
  #+(and lispworks win32) (win32:get-current-process-id)
  #+(and lispworks (not win32)) (system::getpid)
  #+sbcl (sb-posix:getpid)
  #+cmu (unix:unix-getpid)
  #+openmcl (ccl::getpid)
  #+(and clisp unix) (system::process-id)
  #+(and clisp win32) (cond ((find-package :win32)
                             (funcall (find-symbol "GetCurrentProcessId"
                                                   :win32)))
                            (t
                             (system::getenv "PID"))))
