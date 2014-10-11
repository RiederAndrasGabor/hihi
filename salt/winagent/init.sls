msysgit:
  pkg.installed

python2:
  pkg.installed

7zip:
  pkg.installed

get-pip.py:
  file.managed:
    - name: c:/get-pip.py
    - source: https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py
    - source_hash: md5=515f9476562994aa997df488c6c6c080

ez_setup.py:
  file.managed:
    - name: c:/ez_setup.py
    - source: https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
    - source_hash: md5=4cfc24855347d1e01a73ff38830455b4

mingwget.zip:
  file.managed:
    - name: c:/mingwget.zip
    - source: http://heanet.dl.sourceforge.net/project/mingw/Installer/mingw-get/mingw-get-0.6.2-beta-20131004-1/mingw-get-0.6.2-mingw32-beta-20131004-1-bin.zip 
    - source_hash: md5=971778e9330ae006aaeb2d63344be5f3

psutil.exe:
  file.managed:
    - name: c:/psutil.exe
    - source: https://pypi.python.org/packages/2.7/p/psutil/psutil-2.1.3.win32-py2.7.exe
    - source_hash: md5=57ded53eb8082c438f626c9e0de3357a

distutils.cfg:
  file.managed:
    - name: C:\python27\Lib\distutils\distutils.cfg
    - source: salt://winagent/files/distutils.cfg
    - template: jinja 

getpip:
  cmd.run:
    - name: c:/python27/python.exe c:/get-pip.py
    - unless: which pip
    - require:
      - pkg: python2
      - file: get-pip.py
    - reload_modules: True

easy_install:
  cmd.run:
    - name: c:/python27/python.exe c:/ez_setup.py > nul
    - unless: which pip
    - require:
      - pkg: python2
      - file: ez_setup.py
    - reload_modules: True

unzip-mingw:
  cmd.run:
    - name: '"c:/Program Files/7-zip/7z.exe" x -o"C:\MinGW" -y c:/mingwget.zip'
    - require:
      - pkg: 7zip
      - file: mingwget.zip

install_gcc:
  cmd.run:
    - name: 'c:\MinGW\bin\mingw-get install gcc'
    - require:
      - cmd: unzip-mingw
      - win_path: 'C:\MinGW\bin'

pywin32:
  file.managed:
    - name: 'C:/pywin32.exe'
    - source: http://softlayer-ams.dl.sourceforge.net/project/pywin32/pywin32/Build%20219/pywin32-219.win32-py2.7.exe
    - source_hash: md5=f270e9f88155f649fc1a6c2f85aa128d

install_pywin32:
  cmd.run:
    - name: 'c:/Python27/Scripts/easy_install c:/pywin32.exe'
    - require:
      - file: pywin32

git_clone:
  cmd.run:
    - name: '"C:\Program Files (x86)\Git\bin\git.exe" clone {{ pillar['agent']['repo_name'] }} c:/agent'
    - require:
      - pkg: msysgit

pyinstaller_agent:
  cmd.run:
    - name: 'pyinstaller -F --hidden-import pkg_resources --hidden-import infi agent-winservice.py'
    - cwd: 'c:/agent'
