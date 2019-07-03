### 语法分析
#### 实验内容
编写语义分析和翻译程序，实现对算术表达式的类型检查和求值。要求所分析算术表达式由如下的文法产生：
```
E -> E + T|E - T|T
T -> T * F|T / F|F 
F -> num|num.num|( E )
```
#### 文件说明
first.l------------Lex编写的词法分析程序,用于识别词

second.y-----------Yacc编写的语法分析程序，用于识别语法产生式

calc.in------------用于测试的算法表达式

#### 如何运行？
在Ubuntu16.04下
    首先编译yacc文件second.y，注意需要使用命令-d，得到second.tab.h与second.tab.c;
	再用编译first.l生成的C代码lex.yy.c。
	最后联合编译second.tab.c与lex.yy.c，生成可执行文件yaccdemo。


```
bison -d second.y
flex first.l
cc -o yaccdemo second.tab.c lex.yy.c
./yaccdemo < calc.in
```

#### 运行结果说明
如图result.png所示
![运行结果](https://github.com/Macaulish64/Lex-and-Yacc/blob/master/%E7%AC%AC%E4%B8%89%E6%AC%A1%E7%A8%8B%E5%BA%8F%E4%BD%9C%E4%B8%9A/result.png)
#### 最后多说一句
还是要自己写啊同学们。别抄哦
