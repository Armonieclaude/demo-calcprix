# CALCPRIX — RPG ILE Full Free avec Git sur IBM i

> Programme RPG ILE full free démontrant un workflow DevOps complet (dev / recette / production) avec VS Code, Git et GitHub sur IBM i.

## 🗂️ Structure

```
demo-calcprix/
├── qrpglesrc/
│   └── calcprix.rpgle      ← Programme RPG ILE full free
├── scripts/
│   └── build.sh             ← Script de build automatisé (PASE)
└── README.md
```

## 📋 Le programme CALCPRIX

Programme de démonstration qui calcule le prix TTC d'un article avec application de remise. Il illustre :

- Structure RPG ILE moderne (`**FREE`, `CTL-OPT`, `Dcl-S`, `Dcl-Proc`)
- Procédures et interfaces (`Dcl-Pr` / `Dcl-Pi`)
- Data Structures qualifiées (`Dcl-DS ... Qualified`)
- Calculs et affichage (`DSPLY`)

## 🌿 Branches et environnements

```
dev  ──► PR ──►  recette  ──► PR ──►  main
         ✅ CI              ✅ CI
```

| Branche | Environnement | Bibliothèque IBM i | Test |
|---------|---------------|--------------------|------|
| `dev` | Développement | `CALCPXDEV` | `CALL CALCPXDEV/CALCPRIX` |
| `recette` | Recette / QA | `CALCPXRC` | `CALL CALCPXRC/CALCPRIX` |
| `main` | Production | `CALCPRIX` | `CALL CALCPRIX/CALCPRIX` |

## ⚙️ Prérequis

- IBM i V7R5+ avec SSH activé (`STRTCPSVR *SSHD`)
- Git installé en PASE (`yum install git`)
- VS Code avec l'extension **Code for IBM i**

## 🚀 Mise en place

### 1. Cloner sur IBM i

```bash
cd /home/SYLVAIN
git clone https://github.com/Armonieclaude/demo-calcprix.git
cd demo-calcprix
chmod +x scripts/build.sh
```

### 2. Compiler

```bash
./scripts/build.sh dev       # → CALCPXDEV
./scripts/build.sh recette   # → CALCPXRC
./scripts/build.sh prod      # → CALCPRIX
```

### 3. Tester

```
CALL CALCPRIX/CALCPRIX
```

## 🔄 Workflow de développement

1. **Coder** sur la branche `dev` (VS Code via Code for IBM i)
2. **Commiter et pusher** : `git add . && git commit -m "feat: ..." && git push origin dev`
3. **Pull Request** `dev` → `recette` sur GitHub → CI valide → Merge
4. **Build recette** : `./scripts/build.sh recette`
5. **Pull Request** `recette` → `main` sur GitHub → Merge
6. **Build prod** : `./scripts/build.sh prod`

## 📝 Conventions de commits

| Préfixe | Usage |
|---------|-------|
| `feat:` | Nouvelle fonctionnalité |
| `fix:` | Correction de bug |
| `refactor:` | Refactoring |
| `docs:` | Documentation |
| `build:` | Scripts de compilation |

## 👤 Auteur

**Sylvain AKTEPE** — Formateur IBM i, NOTOS (Groupe Armonie)
IBM Champion 2025 & 2026

---

*NOTOS — www.notos.fr — Groupe Armonie*
