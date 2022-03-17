(defpackage nmunro-project
  (:use :cl)
  (:export #:make-project))

(in-package nmunro-project)

(defclass project ()
  ((name    :initarg :name    :initform (error "Must provide a name")    :reader name)
   (path    :initarg :path    :initform (error "Must provide a path")    :reader path)
   (author  :initarg :author  :initform (error "Must provide a author")  :reader author)
   (version :initarg :version :initform (error "Must provide a version") :reader version)
   (license :initarg :license :initform (error "Must provide a license") :reader license))
  (:documentation "A project object"))

(defmethod print-object ((object project) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "~A: ~A" (name object) (path object))))

(defgeneric src (project)
  (:documentation "Gets the src directory of a project"))

(defmethod src ((project project))
  (merge-pathnames #p"src/" (path project)))

(defgeneric tests (project)
  (:documentation "Gets the src directory of a project"))

(defmethod tests ((project project))
  (merge-pathnames #p"tests/" (path project)))

(defgeneric create-project (project)
  (:documentation "Creates the files for a project"))

(defmethod create-project ((project project))
  ;; Create directories
  (ensure-directories-exist (path project))
  (ensure-directories-exist (src project))
  (ensure-directories-exist (tests project))

  ;; Create files
  (create-file project "template.asd" :path (path project)  :name (format nil "~A.asd" (name project)))
  (create-file project "README.md"    :path (path project))
  (create-file project ".gitignore"   :path (path project))
  (create-file project "main.lisp"    :path (src project))
  (create-file project "tests.lisp"   :path (tests project) :name "main.lisp")

  ;; Register newly created project
  (ql:register-local-projects))

(defgeneric create-file (project template &key name path)
  (:documentation "Creates a file for the project"))

(defmethod create-file ((project project) template &key (name nil) (path (path project)))
  (let ((template (djula:compile-template* template))
        (out-name (merge-pathnames (or name template) path)))
    (with-open-file (out out-name :direction :output :if-does-not-exist :create)
       (apply #'djula:render-template* (append `(,template ,out)
                                               `(:project-name    ,(name project)
                                                 :project-author  ,(author project)
                                                 :project-version ,(version project)
                                                 :project-license ,(license project)))))))

(defun make-project (path &key (author (uiop:getenv "USER")) (license "BSD3-Clause") (version "0.0.1") (assume-home-dir t))
  (djula:add-template-directory (asdf:system-relative-pathname "nmunro-project" "src/skeleton/"))

  (flet ((determine-path-type (path)
           (first (pathname-directory path)))

         (check-for-trailing-slash (path)
          (let ((name (namestring path)))
            (if (eq #\/ (char name (- (length name) 1)))
              path
              (pathname (format nil "~A/" name))))))
    (let* ((path (pathname (check-for-trailing-slash path))) ; ensure there's a trailing slash
           (name (car (last (pathname-directory path)))))
      (cond
        (assume-home-dir
         (let ((project (make-instance 'project :name name :path (merge-pathnames path (user-homedir-pathname)) :author author :license license :version version)))
           (create-project project)))

        ((and (not assume-home-dir) (eq :relative (determine-path-type path)))
         (let ((project (make-instance 'project :name name :path (merge-pathnames path (uiop:getcwd)) :author author :license license :version version)))
           (create-project project)))

        ((and (not assume-home-dir) (eq :absolute (determine-path-type path)))
         (let ((project (make-instance 'project :name name :path path :author author :license license :version version)))
           (create-project project)))))))
