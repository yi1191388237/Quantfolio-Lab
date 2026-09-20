@echo off
chcp 65001 >nul
cd /d "%~dp0"
if not exist ".venv\Scripts\streamlit.exe" (
  echo [ERROR] Streamlit environment not found.
  echo Run: .venv\Scripts\python -m pip install -r requirements.txt
  pause
  exit /b 1
)
.venv\Scripts\streamlit.exe run src\quantfolio\app.py
