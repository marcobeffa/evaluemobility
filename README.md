# EvalueMobility - Valutazione Mobilità Articolare

App Rails per il test di valutazione della mobilità articolare con sistema multi-step e parametri URL.

## 🚀 Caratteristiche

- ✅ **Test step-by-step** con barra di progresso
- ✅ **URL parametrici** (`?esercizio=1,2,3...`) per navigazione diretta
- ✅ **9 esercizi di valutazione** + raccolta dati personali
- ✅ **Video dimostrativi** per ogni esercizio
- ✅ **Immagini di riferimento** per i punteggi
- ✅ **Sistema di punteggio** 0-27 punti con classificazione
- ✅ **Responsive design** con TailwindCSS
- ✅ **Condivisione e stampa** risultati
- ✅ **Consensi privacy** GDPR compliant

## 🛠 Tecnologie

- **Rails 8.0** + PostgreSQL
- **TailwindCSS** per lo styling
- **Solid Cache/Queue/Cable** (no Redis richiesto)
- **Importmap** per JavaScript
- **Turbo + Stimulus** per interattività

## 📦 Setup

### Prerequisiti
```bash
# Ruby 3.3.0
# PostgreSQL
# Node.js (per TailwindCSS)
```

### Installazione
```bash
# 1. Genera l'app
rails new evaluemobility --database=postgresql --css=tailwind --javascript=importmap

# 2. Copia i file dall'artifact
cd evaluemobility
# Sostituisci tutti i file con quelli forniti

# 3. Setup dipendenze
bundle install

# 4. Genera model e controller
rails generate model Assessment name:string age:integer email:string phone:string privacy_consent:boolean marketing_consent:boolean notes:text session_token:string current_step:integer flexion_extension:integer arms_overhead:integer spine_rotation_right:integer spine_rotation_left:integer deep_squat:integer hands_behind_back_right:integer hands_behind_back_left:integer straight_leg_raise_right:integer straight_leg_raise_left:integer completed:boolean completed_at:datetime

rails generate controller Assessments start step review update_step create show result

# 5. Setup database
rails db:create
rails db:migrate

# 6. Installa Solid gems
rails generate solid_cache:install
rails generate solid_queue:install  
rails generate solid_cable:install
rails db:migrate

# 7. Avvia il server
rails server
```

## 🎯 Struttura del Test

### Step 1: Dati Personali
- Nome, età, email, telefono
- Consensi privacy e marketing
- Note aggiuntive

### Step 2-10: Esercizi di Valutazione
1. **Flesso-estensione** in avanti (da in piedi)
2. **Braccia sopra la testa** (in piedi)  
3. **Rotazione rachide** - destra
4. **Rotazione rachide** - sinistra
5. **Squat profondo** (a corpo libero)
6. **Mani dietro schiena** - destra sopra
7. **Mani dietro schiena** - sinistra sopra
8. **Sollevamento gamba tesa** - destra
9. **Sollevamento gamba tesa** - sinistra

### Punteggio
- **0-3 punti** per esercizio
- **Totale: 27 punti**
- **Classificazione:**
  - 🔴 0-9: Mobilità Limitata
  - 🟡 10-18: Mobilità Media  
  - 🟢 19-27: Buona Mobilità

## 🌐 Routes

```ruby
# Pagine principali
GET  /                                    # Start (redirect al step 1)
GET  /assessments/step?esercizio=1        # Step con parametri
POST /assessments/update_step             # Aggiorna step
GET  /assessments/review                  # Riepilogo
POST /ass[48;38;185;1216;2590tessments                         # Crea assessment final
GET  /assessments/:id/result              # Risultati completi
```

## 📱 Funzionalità Avanzate

### Navigation
- **Barra progresso** animata
- **Step indicators** cliccabili
- **URL parameters** per accesso diretto
- **Bottoni avanti/indietro**

### Media
- **Video YouTube** embedded per ogni esercizio
- **Placeholder immagini** per riferimenti visivi
- **Icons** per identificazione rapida step

### UX/UI
- **Responsive design** mobile-first
- **Animazioni** smooth per transizioni
- **Validazioni** real-time
- **Feedback visivo** per selezioni

### Privacy & Legal
- **Consenso privacy** obbligatorio
- **Marketing consent** opzionale
- **Session management** con token sicuri
- **GDPR compliance**

## 🚀 Deployment su valutazione.igieneposturale.it

```bash
# Variabili ambiente produzione
export DATABASE_NAME=evaluemobility_production
export DATABASE_USERNAME=postgres_user
export DATABASE_PASSWORD=secure_password
export DATABASE_HOST=localhost
export APP_HOST=valutazione.igieneposturale.it
export RAILS_MASTER_KEY=your_master_key

# Setup produzione
RAILS_ENV=production rails db:create
RAILS_ENV=production rails db:migrate
RAILS_ENV=production rails assets:precompile

# Avvia
RAILS_ENV=production rails server -p 3000
```

### Nginx Configuration
```nginx
server {
    listen 80;
    server_name valutazione.igieneposturale.it;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 🔄 Possibili Miglioramenti

- [ ] **Upload immagini** per ogni esercizio
- [ ] **Sistema utenti** per storico progressi
- [ ] **Email automation** invio risultati
- [ ] **Export PDF** personalizzati  
- [ ] **Analytics** comportamento utenti
- [ ] **A/B testing** per UX
- [ ] **API** per integrazioni esterne
- [ ] **Mobile app** companion

## 📝 License

Sviluppato per **IgienePosturale.it** - 2024
