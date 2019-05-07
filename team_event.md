# 事件是什么？
您可以通过事件代码定义事件，使用事件来跟踪团队的工作情况，从而反映出当前的团队状态
比如您可能需要：当团队三天没有 Commit 时，将团队状态记为 “消极怠工”
为了实现这样的功能，您可以定义一个事件，当 Commit 数据变化时，服务器将会自动运行该事件，根据您定义的事件代码标记团队状态
# 如何定义事件？
您可以使用 javascript 来定义事件，支持 ES6/ES2015 语法
您需要定义一个名为 event 的函数，该函数返回一个字符串，服务器根据该字符串标记团队状态
例如下面的代码：
```javascript
function event() {
  return 'a good team'
}
```
这个事件定义会将所有的团队状态标记为 'a good team'
显然这个事件没有什么作用，为了标记有意义的状态，您可以通过分析团队的 Commit 和 Issues 完成情况来实现
比如刚才的例子：当团队三天没有 Commit 时，将团队状态记为 “消极怠工”
首先您需要获得团队的 Commit 数据，只需要在 event 函数中添加一个函数参数：commits
```javascript
function event(commits) {
  // do something
}
```
事件代码运行时，commits 会自动注入，同理，您也可以引入其他依赖：issues 和 weights
例如：
```javascript
function event(issues, commits, weights) {
  // do something
}
```
注意参数名的拼写，如果使用其他参数名，例如
```javascript
function event(IsSues) {
  // do something
}
```
IsSues 的值将为 `undefined`
commits 为 团队的代码提交情况，格式为 `[["2019-01-01", 4], ["2019-01-03", 5]]`
表示每个日期的 commit 次数
issues 为 团队 issue 完成情况，格式为 `[["2019-01-01", 4], ["2019-01-03", 5]]`
表示每个日期完成的 issue 数目
weights 为 团队 issue weight 完成情况，格式为 `[["2019-01-01", 4], ["2019-01-03", 5]]`
表示每个日期完成的 issue weight
数组按日期排序
现在我们开始实现刚才的例子：
```javascript
// 引入依赖 commits
function event(commits) {
  // 今天
  const day = new Date();
  // 三天前
  day.setDate(day.getDate() - 3);
  day.setHours(0, 0, 0, 0);
  // 最后一天提交
  const last = commits[commits.length-1][0]
  // 转换为本地时区
  const d = new Date(`${last} GMT+8`)
  if (d < day) {
    // 如果最后一次提交日期在三天前
    return '消极怠工';
  }
  // 条件不满足返回 undefined，您也可以手动返回 ''
}
```
创建该事件后，服务器将会把最近三天没有 Commit 的团队标记为 ’消极怠工‘
# 事件运行的时机
事件将会在以下时刻运行：
+ 事件创建或更新之后
+ 团队有新的 Commit 或 完成了新的 Issue
+ 新的一天到来
# 边界情况
当依赖的数据为空时，如 `commits = []`，所有自定义事件都不会运行，团队状态被标记为 '暂无 Commit 或 Issues 数据'
所以您可以确保依赖的数据永远不是空数组
# 代码调试
您可以使用 NodeJS 调试和测试您的代码
# 注意事项
+ 服务端使用 V8 引擎，支持 ES6/ES2015 语法，不支持导入其他库（不能使用 require），您只需要完成简单的逻辑处理
+ 事件限制为 100ms，内存限制为 1Mb
+ 所有运行异常和恶意的脚本都不会运行