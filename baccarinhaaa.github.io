<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mapa Interativo - UniAnchieta</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #3b82f6, #9333ea, #ec4899);
            color: white;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            position: relative;
        }
        .logo {
            width: 100px;
        }
        .qr-menu {
            position: relative;
            cursor: pointer;
            background: rgba(255, 255, 255, 0.2);
            padding: 10px 15px;
            border-radius: 5px;
            font-size: 16px;
        }
        .qr-code {
            display: none;
            position: absolute;
            top: 40px;
            right: 0;
            background: white;
            padding: 10px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
        }
        .qr-code img {
            width: 150px;
        }
        #map {
            height: 500px;
            width: 100%;
            margin: 20px 0;
            border-radius: 10px;
        }
        select {
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
            border: none;
            margin-top: 10px;
            cursor: pointer;
        }
        #info {
            margin: 20px auto;
            padding: 20px;
            width: 80%;
            max-width: 500px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            text-align: left;
        }
    </style>
</head>
<body>
    <header>
        <img src="https://upload.wikimedia.org/wikipedia/commons/3/3c/UniAnchieta.png" alt="Logo UniAnchieta" class="logo">
        
        <div class="qr-menu" onclick="toggleQR()">
            📱 Acesse via QR Code
            <div class="qr-code" id="qrCode">
                <img src="https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=https://seusite.com/mapa" alt="QR Code">
            </div>
        </div>
    </header>

    <h1>Mapa Interativo - UniAnchieta</h1>
    <p>Selecione um local para ver os detalhes:</p>
    <select id="locationSelect">
        <option value="">Escolha um local...</option>
    </select>

    <div id="map"></div>
    <div id="info">
        <h2>Informações do Local</h2>
        <p id="details">Clique em um local no mapa para ver os detalhes.</p>
    </div>

    <script>
        var map = L.map('map').setView([-23.2093, -46.8376], 16);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors'
        }).addTo(map);

        var locais = {
            "Prédio 1": { coords: [-23.214401, -46.891619], curso: "Engenharia da Computação", disciplinas: ["Algoritmos", "Estruturas de Dados"], sala: "101", andar: "1º Andar", professor: "Prof. Carlos Silva", coordenador: "Dra. Mariana Souza", color: "red" },
            "Prédio 2": { coords: [-23.212857, -46.892859], curso: "Administração", disciplinas: ["Gestão Financeira", "Marketing"], sala: "202", andar: "2º Andar", professor: "Prof. Fernanda Lima", coordenador: "Dr. João Almeida", color: "blue" },
            "Prédio 3": { coords: [-23.213977, -46.892892], curso: "Psicologia", disciplinas: ["Psicologia Clínica", "Neurociência"], sala: "303", andar: "3º Andar", professor: "Prof. Ricardo Mendes", coordenador: "Dra. Camila Torres", color: "green" },
            "Prédio 4": { coords: [-23.214460, -46.893431], curso: "Direito", disciplinas: ["Direito Penal", "Direito Civil"], sala: "404", andar: "4º Andar", professor: "Prof. Ana Souza", coordenador: "Dr. Pedro Lima", color: "purple" },
            "Cantina 1": { coords: [-23.214486, -46.892664], color: "orange" },
            "Cantina 2": { coords: [-23.213242, -46.894299], color: "orange" },
            "Anfiteatro": { coords: [-23.215346, -46.891206], color: "yellow" }
        };

        function getIcon(color) {
            return L.icon({
                iconUrl: `https://maps.google.com/mapfiles/ms/icons/${color}-dot.png`,
                iconSize: [32, 32],
                iconAnchor: [16, 32],
                popupAnchor: [0, -32]
            });
        }

        var select = document.getElementById("locationSelect");
        var markers = {};

        Object.keys(locais).forEach(nome => {
            var option = document.createElement("option");
            option.value = nome;
            option.textContent = nome;
            select.appendChild(option);

            var local = locais[nome];
            var marker = L.marker(local.coords, { icon: getIcon(local.color) }).addTo(map)
                .bindPopup(`<strong>${nome}</strong><br>Clique para ver detalhes`)
                .on('click', function () {
                    mostrarDetalhes(nome);
                });

            markers[nome] = marker;
        });

        select.addEventListener("change", function () {
            if (this.value) {
                var local = locais[this.value];
                map.setView(local.coords, 18);
                markers[this.value].openPopup();
                mostrarDetalhes(this.value);
            }
        });

        function mostrarDetalhes(nome) {
            var local = locais[nome];
            var detalhes = `
                <strong>${nome}</strong><br>
                ${local.curso ? `<strong>Curso:</strong> ${local.curso} <br>` : ''}
                ${local.disciplinas && local.disciplinas.length ? `<strong>Disciplinas:</strong> ${local.disciplinas.join(", ")} <br>` : ''}
                ${local.sala ? `<strong>Sala:</strong> ${local.sala} - ${local.andar} <br>` : ''}
                ${local.professor ? `<strong>Professor:</strong> ${local.professor} <br>` : ''}
                ${local.coordenador ? `<strong>Coordenador:</strong> ${local.coordenador}` : ''}
            `;
            document.getElementById("details").innerHTML = detalhes;
        }

        function toggleQR() {
            var qrCode = document.getElementById("qrCode");
            qrCode.style.display = qrCode.style.display === "block" ? "none" : "block";
        }
    </script>
</body>
</html>
