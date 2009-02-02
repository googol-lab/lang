#ifndef _BENCHMARKER_HPP
#define _BENCHMARKER_HPP
#include <ctime>
#include <iostream>

/**
 *  @brief �ץ����μ¹Ի��֤��¬���뤿��Υ��饹
 *         elapsedTime()��Ƥ֤ȡ����󥹥ȥ饯����
 *         �Ƥ����������ηв���֤�msecñ�̤��֤롥
 */
class Benchmarker {
  std::clock_t start_;
  const char *message_;
public:
  explicit
  Benchmarker(const char *mes=0) : start_(std::clock()),message_(mes) {}

  /**
   *  @brief ���󥹥ȥ饯���ޤ���reset()�᥽�åɤ�Ƥ��
   *         ��������ηв���֤�msecñ�̤��֤���
   */
  double elapsedTime() {
    return (clock()-start_)*1000.0/CLOCKS_PER_SEC;
  }

  /**
   *  @brief �в���֤�ꥻ�åȤ��롥
   */
  void reset() {
    start_ = std::clock();
  }

  ~Benchmarker(){
    if(message_){
      std::cerr << message_ << " "
		<< elapsedTime() << "[msec]" << std::endl;
    }
  }
};

#endif // _BENCHMARKER_HPP
