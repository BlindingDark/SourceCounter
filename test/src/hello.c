#include <stdio.h>

int main()
{
  /*
     多行注释，下面一行算空行

     多行注释
  */
  printf("Hello, \\\\World! \n"); /* 多行注释
                                     多行注释 *\/ printf("Hello, /* World! \n"); // 单行注释
                                     多行注释 */ printf("Hello, /* World! \n"); // 单行注释

  // 单行注释，下面一行算注释
  //

  /* 单行注释 */
  return 0; // 同行注释
}
