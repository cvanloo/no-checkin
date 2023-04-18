#!/usr/bin/env janet

(use sh)

(def forbidden-words @["nocheckin" "dbg!"])

(def files-str ($< git diff --staged --name-only --diff-filter=d))

(def files (let [files (string/split "\n" files-str)]
             (take (- (length files) 1) files)))
(def errors @[])

(def colors @{:clear "\e[0m"
              :red "\e[31m"
              :blue "\e[34m"})

(each word forbidden-words
  (each file files
    (if ($? git grep -q -E -iF ,word "--" ,file)
      (array/push errors (string
                           "disallowed expression "
                           (colors :red) word (colors :clear)
                           " in file "
                           (colors :blue) file (colors :clear))))))

(if (not (empty? errors))
  (do
    (each err errors (print "[No-Checkin] " err))
    (os/exit 1)))
