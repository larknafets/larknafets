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
Uptime ........ 47.2 years (booted at 337 ppm CO2)
Focus ......... Sustainable IT, renewable energy, efficiency
Optimizing .... Watts, bytes and meetings
Principle ..... Make it work, make it right, make it fast.
Mode .......... Cloudy with a chance of surplus
```

```console
stefan@kral:~$ gh stats --refresh 24h --top 3
Repos ......... 13
Commits ....... 705
PRs ........... 74
Merged ........ 73
Lines of code . 129.4k (+100.9k / -28.5k)

nebenkostenrechner . 469 commits
gcs-connector-evcc . 47 commits
ha-addons .......... 33 commits
```

```console
stefan@kral:~$ ls -l ~/contact
linkedin -> linkedin.com/in/stefan-kral
github   -> github.com/larknafets
500px    -> 500px.com/p/stefankral
```
