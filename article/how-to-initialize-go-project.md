---
title: "How to initialize go project"
date: "2021-10-05"
---

매번 찾아보게되어 기록을 남긴다.

```

$ pwd
/home/donghee/Workspace/github.com/dongheejeong

```

```

export NAME="go-project-name"
mkdir $NAME
cd $NAME
go mod init github.com/dongheejeong/$NAME

```

```

$ cat go.mod
module github.com/dongheejeong/how-to-init-go-project

go 1.17

```


참고: <https://www.youtube.com/watch?v=Ot9Em123Fz8>
