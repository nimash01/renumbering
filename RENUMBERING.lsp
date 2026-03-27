(defun c:RENUM ( / lays lay ss n ent att tag total )

  (setq total (getint "\nEnter total number of sheets: "))

  (prompt "\nUpdating sheet numbers...")

  (setq lays (layoutlist))

  (foreach lay lays
    (if (/= (strcase lay) "MODEL")
      (progn

        (setvar "CTAB" lay)
        (prompt (strcat "\nLayout: " lay))

        (setq ss (ssget "X" (list '(0 . "INSERT") (cons 410 lay))))

        (if ss
          (progn
            (setq n 0)

            (while (< n (sslength ss))

              (setq ent (ssname ss n))
              (setq att (entnext ent))

              (while (and att (= (cdr (assoc 0 (entget att))) "ATTRIB"))

                (setq tag (strcase (cdr (assoc 2 (entget att)))))

                (if (= tag "SHEET_NUMBER")
                  (progn

                    (entmod
                      (subst
                        (cons 1 (strcat lay " OF " (itoa total)))
                        (assoc 1 (entget att))
                        (entget att)
                      )
                    )

                    (prompt
                      (strcat "\nUpdated to: " lay " OF " (itoa total))
                    )
                  )
                )

                (setq att (entnext att))
              )

              (setq n (+ n 1))
            )
          )
        )

      )
    )
  )

  (princ "\nSheet renumbering complete.")
  (princ)
)