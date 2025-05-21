# Students GetById Service

Servicio responsable de obtener la información de un estudiante específico por su ID.

## Funcionalidad

Este servicio expone un endpoint GET que permite obtener los detalles de un estudiante específico utilizando su identificador único.

## Especificaciones Técnicas

- **Puerto**: 8083 (interno), 30083 (NodePort)
- **Endpoint**: GET `/students/{id}`
- **Runtime**: Go
- **Base de Datos**: MongoDB

## Estructura del Servicio

```
students-getbyid-service/
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── src/
│   ├── main.go
│   ├── handlers/
│   ├── models/
│   └── config/
├── Dockerfile
└── README.md
```

## API Endpoint

### GET /students/{id}

Retorna la información detallada de un estudiante específico.

#### URL Parameters
- `id`: ID único del estudiante (requerido)

#### Response
```json
{
    "id": "string",
    "name": "string",
    "age": number,
    "email": "string",
    "created_at": "timestamp"
}
```

#### Error Response
```json
{
    "error": "string",
    "message": "string"
}
```

## Configuración Kubernetes

### Deployment
- **Replicas**: 3
- **Imagen**: hamiltonlg/students-getbyid-service:latest
- **Variables de Entorno**:
  - MONGO_URI: mongodb://mongo-service:27017

### Service
- **Tipo**: NodePort
- **Puerto**: 8083 -> 30083

## Despliegue

```bash
kubectl apply -f k8s/
```

## Verificación

1. Verificar el deployment:
```bash
kubectl get deployment students-getbyid-deployment
```

2. Verificar los pods:
```bash
kubectl get pods -l app=students-getbyid
```

3. Verificar el servicio:
```bash
kubectl get svc students-getbyid-service
```

## Pruebas

### Obtener un estudiante por ID
```bash
curl http://localhost:30083/students/12345
```

## Logs

Ver logs de un pod específico:
```bash
kubectl logs -f <pod-name>
```

## Monitoreo

### Métricas Importantes
- Tiempo de respuesta del endpoint
- Tasa de éxito/error en búsquedas
- Uso de recursos (CPU/Memoria)
- Latencia de consulta a MongoDB

## Solución de Problemas

1. **Error de Conexión a MongoDB**:
   - Verificar la variable MONGO_URI
   - Comprobar conectividad con mongo-service
   - Revisar logs de MongoDB

2. **Estudiante No Encontrado**:
   - Verificar el formato del ID
   - Comprobar existencia en la base de datos
   - Revisar logs de la aplicación

3. **Pod en CrashLoopBackOff**:
   - Verificar logs del pod
   - Comprobar recursos asignados
   - Verificar configuración del deployment

4. **Servicio no accesible**:
   - Verificar el estado del service
   - Comprobar la configuración de NodePort
   - Verificar reglas de firewall

## Optimización

1. **Índices MongoDB**:
   - Asegurar índice en el campo _id
   - Mantener estadísticas actualizadas

2. **Caché**:
   - Implementar caché para IDs frecuentemente consultados
   - Configurar tiempo de expiración apropiado

3. **Validación**:
   - Implementar validación robusta de IDs
   - Manejar formatos inválidos de ID 