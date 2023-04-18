#!/usr/bin/env janet

(use sh)

(def forbidden-words @["nocheckin" "dbg!"])

(def files-str ($< git diff --staged --name-only --diff-filter=d))

(def files (let [files (string/split "\n" files-str)]
             (take (- (length files) 1) files)))
(def errors @[])

(def color-table @{:clear "\e[0m"
                   :red "\e[31m"
                   :blue "\e[34m"})

(each word forbidden-words
  (each file files
    (if ($? git grep -q -E -iF ,word "--" ,file)
      (array/push errors (string
                           "disallowed expression "
                           (color-table :red) word (color-table :clear)
                           " in file "
                           (color-table :blue) file (color-table :clear))))))

(if (not (empty? errors))
  (do
    (each err errors (print err))
    (os/exit 1)))
