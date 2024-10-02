import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Queen project 8x8'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> solutions = [];
  int total = 0;
  String desc = '';

  void calculateRes() {
   // solutions = solveQueens();
    NQueensSolverIterative solver = NQueensSolverIterative(8);
    // NQueensSolver solver = NQueensSolver(8);
    List<List<int>> solutions = solver.solveNQueens();
    print('解達總數量: ${solutions.length}\n');

    total = solutions.length;

    int n = total; // 想要呈現的數量
    // 顯示前n個解答
    for (int i = 0; i < (solutions.length < n ? solutions.length : n); i++) {

      desc = desc + '// 解答 ${i + 1}\n' ;
      String str = solver.getBoardStr(solutions[i]);
      desc = desc + str +  '\n';
    }

    print(desc);

    setState(() {
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              const Text(
                '點擊右下角 Button 開始計算',
              ),
              SizedBox(height: 5,),
              Text(
                '總數量: $total',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 5,),

              Text(
                '執行結果: $desc',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
          
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: calculateRes,
        tooltip: 'run',
        child: const Icon(Icons.run_circle_outlined,size: 50,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NQueensSolverIterative {
  final int n;
  List<List<int>> solutions = [];

  NQueensSolverIterative(this.n);

  List<List<int>> solveNQueens() {
    // 初始化栈，每个元素是一个数组，表示当前的棋盘状态
    // 每个状态包含两个列表：放置的列和当前行
    List<int> board = List.filled(n, -1);
    List<int> cols = List.filled(n, 0); // 记录每列是否被占用
    List<int> diag1 = List.filled(2 * n - 1, 0); // 對角線
    List<int> diag2 = List.filled(2 * n - 1, 0); // 對角線

    int row = 0;
    int col = 0;

    while (row >= 0) {
      while (col < n) {
        if (cols[col] == 0 &&
            diag1[row + col] == 0 &&
            diag2[n - 1 + row - col] == 0) {
          // 放置皇后
          board[row] = col;
          cols[col] = 1;
          diag1[row + col] = 1;
          diag2[n - 1 + row - col] = 1;

          // 移動到下一行
          row++;
          col = 0;

          // 如果所有 Q 都已放置，紀錄解决方案
          if (row == n) {
            solutions.add(List.from(board));
            // 回溯到上一行
            row--;
            col = board[row] + 1;
            cols[board[row]] = 0;
            diag1[row + board[row]] = 0;
            diag2[n - 1 + row - board[row]] = 0;
          }

          break;
        } else {
          col++;
        }
      }

      if (col == n) {
        // 無法在當前row找到合法的位置，回溯
        row--;
        if (row < 0) {
          break;
        }
        col = board[row] + 1;
        cols[board[row]] = 0;
        diag1[row + board[row]] = 0;
        diag2[n - 1 + row - board[row]] = 0;
      }
    }

    return solutions;
  }

  /// 產生棋盤布局字串
  String getBoardStr(List<int> board) {
    String str = '';
    for (int row = 0; row < n; row++) {
      String line = '';
      for (int col = 0; col < n; col++) {
        if (board[row] == col) {
          line += ' Q ';
        } else {
          line += ' . ';
        }
      }
      // print(line);
      str = str + line + '\n';
    }
    return str;
  }
}

class NQueensSolver {
  int n;
  List<List<int>> solutions = [];

  NQueensSolver(this.n);

  List<List<int>> solveNQueens() {
    List<int> board = List.filled(n, -1);
    _backtrack(0, board, <List<int>>[]);
    return solutions;
  }

  /// 回溯算法的核心函数
  void _backtrack(int row, List<int> board, List<List<int>> solutions) {
    if (row == n) {
      // 找到一個解决方案，複製並加入到结果中
      solutions.add(List.from(board));
      return;
    }

    for (int col = 0; col < n; col++) {
      if (_isSafe(row, col, board)) {
        board[row] = col;
        _backtrack(row + 1, board, solutions);
        board[row] = -1; // 回溯
      }
    }


    if (row == 0) {
      this.solutions = solutions;
    }
  }

  /// 检查在 (row, col) 放置 Q 是否安全
  bool _isSafe(int row, int col, List<int> board) {
    for (int i = 0; i < row; i++) {
      if (board[i] == col ||
          board[i] - i == col - row ||
          board[i] + i == col + row) {
        return false;
      }
    }
    return true;
  }

  /// 產生棋盤布局字串
  String getBoardStr(List<int> board) {
    String str = '';

    for (int row = 0; row < n; row++) {
      String line = '';
      for (int col = 0; col < n; col++) {
        if (board[row] == col) {
          line += ' Q ';
        } else {
          line += ' . ';
        }
      }
      // print(line);
      str = str + line + '\n';
    }
    return str;
  }
}
