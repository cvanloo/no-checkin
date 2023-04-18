#!/usr/bin/env janet

(use sh)

(def forbidden-words @["nocheckin" "dbg!"])

(def files-str ($< git diff --staged --name-only --diff-filter=d))

(def files (let [files (string/split "\n" files-str)]
             (take (- (length files) 1) files)))
(def errors @[])

(each word forbidden-words
  (each file files
    (if ($? git grep -q -E -iF ,word "--" ,file)
      (array/push errors (string "disallowed expression " word " in file " file)))))

(if (not (empty? errors))
  (do
    (each err errors (print err))
    (os/exit 1)))
