```console
stefan@kral:~$ sudo systemctl status larknafets
● larknafets.service - Stefan Kral
     Active: active (running)
     Status: "200 OK"
```

```console
stefan@kral:~$ neofetch
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢐⢐⢐⢐⢑⠌⡆⡣⡱⡑⡕⣕⢕⡕⡬⡪⡊⡂⢂⢂⢂⠆⡂⠄⠄⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠕⣔⣵⣶⣷⡷⡮⣂⡪⡨⢢⢣⠣⡃⡑⡐⢔⢡⡢⡱⠨⠠⡁⡂⠄⠂⡀⠀⠀
⠀⠀⠀⠀⠀⠀⡂⠅⠅⡀⠀⠡⠋⠃⠂⠂⠁⠁⠝⢙⠪⠮⡈⡢⡐⡔⣕⣵⡣⡣⢊⠌⡂⡂⡢⢁⠂⠄⢀⠀
⠀⠀⠀⠀⢀⢂⠪⡘⡨⠠⠈⠀⡀⢄⣤⣴⣼⣾⣾⣾⣾⣦⣬⣜⢞⢺⣽⢾⠨⢂⢁⢂⠂⡂⢂⠂⠌⠠⠀⠀
⠀⠀⠀⡀⡂⡢⢑⠐⠄⠅⢈⢰⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣅⠫⠣⢑⢐⢐⠠⠂⡂⠂⠌⠈⠄⠂⠀
⠀⠀⠠⢂⠊⠄⠅⠌⡂⠡⢰⣿⣿⣿⣿⣿⣿⡿⡿⠿⢿⢿⣿⣿⣿⣿⣧⠐⠀⠂⡀⢂⠁⠠⠁⠌⠀⠄⠐⠀
⠀⡈⠌⡐⡈⠈⢈⠐⠠⠈⡪⡟⠟⢿⣿⣿⡯⡂⠀⠀⠀⠁⠉⢛⠿⣿⣗⠕⠀⠀⠐⡀⠌⠀⠅⢀⠁⠀⠄⠁
⠠⠀⠂⢐⠠⢀⠀⡈⠄⠀⠀⠀⠀⣼⣿⣿⣿⣢⢀⢀⢄⢔⢄⢔⡨⣽⣿⣇⠄⠀⠠⠀⠂⡁⠄⢀⠀⠁⠐⠀
⠀⡀⠀⠑⠅⠢⢈⠠⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⡿⡀⠀⠀⠈⡀⠄⠐⢀⠠⢀⠅⡂
⠀⠀⠀⠠⠡⠑⡀⡂⠌⠀⢀⢜⠙⠙⠙⠉⠛⣿⣿⣿⣿⣿⣿⣿⣿⢿⡛⡎⡪⡠⣠⣢⣰⢰⡱⣕⢞⢦⢓⢌
⠀⠀⠨⠨⢈⢐⠠⢂⢂⢰⣸⣖⠄⠀⠀⢐⢐⣴⣿⣿⣿⣿⣿⣿⡣⡣⠣⡑⠌⠢⡡⡡⠑⡵⡹⡪⡣⠣⡃⡂
⠀⠀⠌⠨⠐⡐⢌⠢⡑⡐⢕⣟⠍⠀⠀⠈⠚⠻⡻⢿⢿⣿⣿⢳⠱⡑⡱⠨⠨⠨⠪⡂⠌⡎⢇⢇⠣⡑⠠⠀
⠀⡈⠨⠀⡑⠌⡢⡑⡈⢀⠘⠑⠀⠀⠀⠈⠐⠠⡰⡠⡑⠝⡎⡇⢇⠕⢜⠨⠀⠁⠠⠑⠁⠊⠢⠑⠈⠀⠀⠀
⠀⢀⢂⠢⡐⢔⢱⢸⢸⠢⠀⠀⠀⠀⠀⠀⠀⠀⠐⠐⡈⡐⡁⠪⡐⠅⠅⠠⠀⡀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀
⠀⢀⠢⠑⢁⠣⡑⡅⡅⢌⠀⠀⠀⠀⠀⠀⠠⠢⡑⡅⡢⢐⠨⢐⠠⢁⠁⠐⠀⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠠⠑⡐⠔⢌⢪⠸⡐⠀⠀⠀⠀⠀⠀⠀⠀⠐⠈⠀⠅⠈⠠⠀⠄⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠀⠁⠁⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

Name .......... Stefan Kral
Role .......... Senior IT Consultant
Location ...... ~/nordsee (remote-first, tide-driven)
Uptime ........ 47.3 years
Focus ......... Sustainable IT, renewable energy, efficiency
Optimizing .... watts, bytes and meetings
Principles .... Simple > clever, tested > hopeful, boring tech wins
Mode .......... pragmatic, curious, learns by doing
```

```console
stefan@kral:~$ git log --oneline -3
a1b2c3d Ship small, ship often
d4e5f6a Delete more code than I write
0f1e2d3 Make it work, make it right, make it fast (in that order)
```

```console
stefan@kral:~$ gh stats --refresh 24h
Uptime ........ 10y 8m
Repos ......... 12
Commits ....... 812
PRs ........... 75
Merged ........ 73
Lines of code . 129.1k (+100.7k / -28.4k)
```

```console
stefan@kral:~$ ls -l ~/contact
linkedin -> linkedin.com/in/stefan-kral
github   -> github.com/larknafets
```

```console
stefan@kral:~$ echo "stefan kral" | rev | tr -d " "
larknafets
```
