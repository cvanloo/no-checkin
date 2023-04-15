#!/usr/bin/env janet

(use sh)

(def forbidden-words @["nocheckin" "dbg!"])

(def files-str @"")
($ git diff --staged --name-only --diff-filter=d >,files-str)

(def files (filter
             (fn [a] (not= a ""))
             (string/split "\n" files-str)))
(def errors @[])

(each word forbidden-words
  (each file files
    (if ($? git grep -q -E -iF ,word "--" ,file)
      (array/push errors (string "disallowed expression " word " in file " file)))))

(if (not (empty? errors))
  (do
    (each err errors (print err))
    (error "commit aborted!")))
