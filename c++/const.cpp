#include <iostream>
using namespace std;

int main()
{
  int a = 3;

  const int *x = &a;  // �ݥ��󥿤λؤ��褬const
  //int * const x = &a; // �ݥ��󥿼��Τ�const

  x = 0;
  cout << *x << endl;

  return 0;
}
