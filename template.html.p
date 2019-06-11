<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>◊(select-from-metas 'title here) | Tome</title>
        <link rel="stylesheet" type="text/css" href="/assets/css/tufte.css"/>
        <meta name="viewport" contents="width=device-width, initial-scale=1">
    </head>

    <body>
        <article>
            <h1 id="◊text->id{◊(select-from-metas 'title here)}">◊(select-from-metas 'title here)</h1>
            <p class="subtitle">◊(get-author here)</p>
            ◊(->html doc #:splice? #t)

            <section>
                <p>This page was generated on: ◊(get-current-date) and published on: ◊(published-date here)</p>
            </section>
        </article>
    </body>
</html>
