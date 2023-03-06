;;; ruby-ts-mode.el --- Major mode for editing Ruby files using tree-sitter -*- lexical-binding: t; -*-

;; Copyright (C) 2022-2023 Free Software Foundation, Inc.

;; Author: Perry Smith <pedz@easesoftware.com>
;; Created: December 2022
;; Keywords: ruby languages tree-sitter

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This file defines ruby-ts-mode which is a major mode for editting
;; Ruby files that uses Tree Sitter to parse the language. More
;; information about Tree Sitter can be found in the ELisp Info pages
;; as well as this website: https://tree-sitter.github.io/tree-sitter/

;; For this major mode to work, Emacs has to be compiled with
;; tree-sitter support, and the Ruby grammar has to be compiled and
;; put somewhere Emacs can find it.  See the docstring of
;; `treesit-extra-load-path'.

;; This mode doesn't associate itself with .rb files automatically.
;; You can do that either by prepending to the value of
;; `auto-mode-alist', or using `major-mode-remap-alist'.

;; Tree Sitter brings a lot of power and versitility which can be
;; broken into these features.

;; * Font Lock

;; The ability to color the source code is not new but what is new is
;; the versatility to enable and disable particular font lock rules.
;; I suggest reviewing variable treesit-font-lock-level and function
;; treesit-font-lock-recompute-features to get a better understanding
;; of the following.

;; Currently tree treesit-font-lock-feature-list is set with the
;; following levels:
;;   1: comment method-definition
;;   2: keyword regexp string type
;;   3: builtin constant delimiter escape-sequence
;;      global instance
;;      interpolation literal symbol variable
;;   4: bracket error function operator punctuation

;; Thus if treesit-font-lock-level is set to level 3 which is its
;; default, all the features listed in levels 1 through 3 above will
;; be enabled.  i.e. those features will font lock or colorize the
;; code accordingly.  Individual features can be added and removed via
;; treesit-font-lock-recompute-features.

;; describe-face can be used to view how a face looks.

;; * Indent

;; ruby-ts-mode tries to adhere to the indentation related user
;; options from ruby-mode, such as ruby-indent-level,
;; ruby-indent-tabs-mode, and so on.

;; * IMenu
;; * Navigation
;; * Which-func

;;; Code:

(require 'treesit)

(declare-function treesit-parser-create "treesit.c")


(defvar regex-ts-mode--treesit-font-lock-settings
  (treesit-font-lock-rules

   :language 'regex
   :feature 'operator
   `(["*" "+" "?" "|" "=" "<=" "!" "<!"] @font-lock-type-face)

   :language 'regex
   :feature 'constant
   `((class_character) @font-lock-constant-face))

   

  "Tree-sitter font-lock settings for `haskell-ts-mode'.")

;;;###autoload
(define-derived-mode regex-ts-mode prog-mode "Regex"
  :group 'regex

    (unless (treesit-ready-p 'regex)
     (error "Tree-sitter for Regex is not available"))
    (treesit-parser-create 'regex)

    ;; Font-lock.
    (setq-local treesit-font-lock-settings regex-ts-mode--treesit-font-lock-settings)
    (setq-local treesit-font-lock-feature-list
      '(( type keyword include definition function variable comment conditional)))

    (treesit-major-mode-setup))

(provide 'regex-ts-mode)
