◊(local-require racket/file racket/system)

◊(define latex-source ◊string-append{
    \documentclass{tufte-handout}
    \usepackage{hyperref}
    \usepackage{graphicx}
    \setkeys{Gin}{width=\linewidth,totalheight=\textheight,keepaspectratio}
    \usepackage{amsmath}

    \title{◊(select-from-metas 'title here)}

    \author{◊(get-author)}

    \date{◊(published-date)}

    \begin{document}

    \maketitle

    ◊(apply string-append (cdr doc))

    \end{document}
})

◊(define working-directory
    (make-temporary-file "pollen-latex-work-~a" 'directory))
◊(define temp-tex-path (build-path working-directory "temp.tex"))
◊(display-to-file latex-source temp-tex-path #:exists 'replace)
◊(define command (format "pdflatex -output-directory ~a ~a"
    working-directory temp-tex-path))
◊(unless
    (for/and ([i (in-range 3)])
             (system command))
    (error "pdflatex: rendering error"))
◊(let ([pdf (file->bytes (build-path working-directory "temp.pdf"))])
   (delete-directory/files working-directory)
   pdf)