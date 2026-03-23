#!/bin/bash
ENV=${1:-dev}
REPO_DIR="/home/SYLVAIN/demo-calcprix"
SRC_DIR="$REPO_DIR/qrpglesrc"

case $ENV in
  dev)     BIBLIO="CALCPXDEV"; BRANCH="dev" ;;
  recette) BIBLIO="CALCPXRC";  BRANCH="recette" ;;
  prod)    BIBLIO="CALCPRIX";  BRANCH="main" ;;
  *)       echo "❌ Usage : ./build.sh [dev|recette|prod]"; exit 1 ;;
esac

echo "============================================"
echo "🔨 BUILD — $ENV"
echo "📚 Bibliothèque : $BIBLIO"
echo "🌿 Branche      : $BRANCH"
echo "============================================"

cd "$REPO_DIR"
git checkout "$BRANCH"
git pull origin "$BRANCH"

system "CHKOBJ PGM($BIBLIO) OBJTYPE(*LIB)" 2>/dev/null
if [ $? -ne 0 ]; then
  system "CRTLIB LIB($BIBLIO) TEXT('Calcul Prix - $ENV')"
fi

for src in "$SRC_DIR"/*.rpgle; do
  if [ -f "$src" ]; then
    pgm=$(basename "$src" .rpgle | tr '[:lower:]' '[:upper:]')
    echo "  ⚙️  Compilation de $pgm..."
    system "CRTBNDRPG PGM($BIBLIO/$pgm) SRCSTMF('$src') DBGVIEW(*SOURCE) REPLACE(*YES) TGTCCSID(*JOB)" 2>/dev/null
    if [ $? -eq 0 ]; then echo "  ✅ $pgm compilé"; else echo "  ❌ Erreur $pgm"; exit 1; fi
  fi
done

for src in "$SRC_DIR"/*.sqlrpgle; do
  if [ -f "$src" ]; then
    pgm=$(basename "$src" .sqlrpgle | tr '[:lower:]' '[:upper:]')
    echo "  ⚙️  Compilation de $pgm (SQL)..."
    system "CRTSQLRPGI PGM($BIBLIO/$pgm) SRCSTMF('$src') COMMIT(*NONE) DBGVIEW(*SOURCE) REPLACE(*YES) TGTCCSID(*JOB) CVTCCSID(*JOB)" 2>/dev/null
    if [ $? -eq 0 ]; then echo "  ✅ $pgm compilé"; else echo "  ❌ Erreur $pgm"; exit 1; fi
  fi
done

echo "============================================"
echo "✅ BUILD TERMINÉ — $BIBLIO"
echo "📅 $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"
