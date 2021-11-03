from pathlib import Path # https://stackoverflow.com/questions/2186525/how-to-use-glob-to-find-files-recursively
import pypandoc
import markdown
import jinja2
import os



class Article:
    def __init__(self, fname, category, metadata):
        self.fname = fname
        self.category = category
        
        # https://python-markdown.github.io/extensions/meta_data/#accessing-the-meta-data
        self.metadata = metadata


    def __str__(self):
        return f'Article(fname: {self.fname}, category: {self.category}, metadata: {self.metadata})'

    __repr__ = __str__



def get_articles(wd='.'):
    articles = []
    # https://python-markdown.github.io/extensions/meta_data/#accessing-the-meta-data
    md = markdown.Markdown(extensions = ['meta'])

    for path in Path(wd).rglob('*.md'):
        fname = path.name
        category = path.parts[-2]

        with open(path, "r", encoding="utf-8") as f:
          text = f.read()
        md.convert(text)

        articles.append(Article(fname, category, md.Meta))

    return articles



def get_categories(wd="."):
    dirEntries = os.scandir(wd)
    return [e.name for e in dirEntries if e.is_dir() is True and not e.name.startswith(".")]



articles = get_articles('article/')
categories = get_categories('article/')
print(f"articles: {articles}")
print(f"categories: {categories}")


#
# Template root index.html
#
print("")
print("Templating root index.html..")
template = jinja2.Template(open('template/index.html.j2').read())

data = {
        "categories": categories,
        "recent_articles": sorted(articles, key = lambda article: article.metadata["date"][0], reverse = True)[:min(len(articles), 5)],
        "commit_sha": os.getenv("COMMIT_SHA"),
        "commit_url": os.getenv("COMMIT_URL"),
        }

ret = template.render(data=data)
with open("build/index.html", "w") as html:
    html.write(ret)
print("Done.")


#
# Template category index.html
#
print("")
print("Templating category index.html..")
template = jinja2.Template(open('template/category_index.html.j2').read())

for category in categories:
    print(f"{category}")

    category_articles = [ a for a in articles if a.category == category ]
    data = {
            "category": category,
            # article date 기준 내림차순 정렬
            "articles": sorted(category_articles, key = lambda article: article.metadata["date"][0], reverse = True),
            }

    ret = template.render(data=data)
    os.mkdir(f"build/{category}", 0o755)
    with open(f"build/{category}/index.html", "w") as html:
        html.write(ret)
print("Done")


#
# Template all_articles.html
#
print("")
print("Templating all_articles.html..")
template = jinja2.Template(open('template/all_articles.html.j2').read())

data = {
        # article date 기준 내림차순 정렬
        "articles": sorted(articles, key = lambda article: article.metadata["date"][0], reverse = True),
        }

ret = template.render(data=data)
with open(f"build/all_articles.html", "w") as html:
    html.write(ret)
print("Done")


#
# Template each article
#
print("")
print("Templating each article..")
for article in articles:
    print(f"{article}")

    html_j2 = pypandoc.convert_file(
            f'article/{article.category}/{article.fname}',
            'html',
            extra_args=['--template', 'template/general_article.pandoc-tmpl.html'],
            )

    template = jinja2.Template(html_j2)
    
    data = {
            "article": article
            }
    
    ret = template.render(data=data)
    with open(f"build/{article.category}/" + article.fname.replace(".md", ".html"), "w") as html:
        html.write(ret)
print("Done")


#
# Template error.html
#
print("")
print("Templating error.html..")
html_j2 = pypandoc.convert_file(
        'error.md',
        'html',
        extra_args=['--template', 'template/general_article.pandoc-tmpl.html'],
        )

template = jinja2.Template(html_j2)

ret = template.render(data={})
with open(f"build/error.html", "w") as html:
    html.write(ret)
print("Done")
