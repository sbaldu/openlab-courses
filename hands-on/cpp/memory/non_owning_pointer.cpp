#include <cstdlib>
#include <cstring>
#include <memory>

char *some_api();

int main() {
  auto *p = some_api();

  // std::free(p);
  // delete p;
  // delete [] p;
}

char *some_api() {
  static char s[] = "Hello, world!";
  return std::strstr(s, "orl");
}
