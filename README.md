# Students GetById Service

Este servicio es parte del sistema de gestión de estudiantes y se encarga de obtener la información detallada de un estudiante específico por su ID.

## Estructura del Servicio

```
students-getbyid-service/
├── controllers/     # Controladores REST
├── models/         # Modelos de datos
├── repositories/   # Capa de acceso a datos
├── services/      # Lógica de negocio
├── k8s/           # Configuraciones de Kubernetes
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── test/          # Scripts de prueba
    └── test-getbyid.sh
```

## Endpoints

### GET /students/{id}
Obtiene los detalles de un estudiante específico por su ID.

**Parámetros de URL:**
- `id`: ID del estudiante (ObjectId)

**Response (200 OK):**
```json
{
    "id": "string",
    "name": "string",
    "age": number,
    "email": "string"
}
```

**Response (404 Not Found):**
```json
{
    "error": "Student not found"
}
```

## Configuración Kubernetes

### Deployment
El servicio se despliega con las siguientes especificaciones:
- Replicas: 1
- Puerto: 8080
- Imagen: students-getbyid-service:latest

### Service
- Tipo: NodePort
- Puerto: 8080
- NodePort: 30083

### Ingress
- Path: /students/{id}
- Servicio: students-getbyid-service
- Puerto: 8080

## Despliegue en Kubernetes

### 1. Aplicar configuraciones
```bash
# Crear el deployment
kubectl apply -f k8s/deployment.yaml

# Crear el service
kubectl apply -f k8s/service.yaml

# Crear el ingress
kubectl apply -f k8s/ingress.yaml
```

### 2. Verificar el despliegue
```bash
# Verificar el deployment
kubectl get deployment students-getbyid-deployment
kubectl describe deployment students-getbyid-deployment

# Verificar los pods
kubectl get pods -l app=students-getbyid
kubectl describe pod -l app=students-getbyid

# Verificar el service
kubectl get svc students-getbyid-service
kubectl describe svc students-getbyid-service

# Verificar el ingress
kubectl get ingress students-getbyid-ingress
kubectl describe ingress students-getbyid-ingress
```

### 3. Verificar logs
```bash
# Ver logs de los pods
kubectl logs -l app=students-getbyid
```

### 4. Escalar el servicio
```bash
# Escalar a más réplicas si es necesario
kubectl scale deployment students-getbyid-deployment --replicas=3
```

### 5. Actualizar el servicio
```bash
# Actualizar la imagen del servicio
kubectl set image deployment/students-getbyid-deployment students-getbyid=students-getbyid-service:nueva-version
```

### 6. Eliminar recursos
```bash
# Si necesitas eliminar los recursos
kubectl delete -f k8s/ingress.yaml
kubectl delete -f k8s/service.yaml
kubectl delete -f k8s/deployment.yaml
```

## Pruebas

El servicio incluye un script de pruebas automatizadas (`test/test-getbyid.sh`) que verifica:

1. Obtención exitosa de un estudiante
2. Manejo de ID inexistente
3. Manejo de ID inválido
4. Verificación de formato de respuesta

Para ejecutar las pruebas:
```bash
./test/test-getbyid.sh
```

También se puede ejecutar como parte de la suite completa de pruebas:
```bash
./test-all-services.sh
```

### Casos de Prueba

1. **Test 1:** Obtener estudiante existente
   - Crea un estudiante de prueba
   - Verifica la obtención correcta
   - Valida el formato de respuesta

2. **Test 2:** Intentar obtener estudiante inexistente
   - Usa un ID válido pero inexistente
   - Verifica el mensaje de error apropiado

3. **Test 3:** Probar con ID inválido
   - Usa un formato de ID incorrecto
   - Verifica el manejo de error

4. **Test 4:** Verificar formato de respuesta
   - Comprueba todos los campos requeridos
   - Valida los tipos de datos

## Variables de Entorno

- `MONGODB_URI`: URI de conexión a MongoDB (default: "mongodb://mongo-service:27017")
- `DATABASE_NAME`: Nombre de la base de datos (default: "studentsdb")
- `COLLECTION_NAME`: Nombre de la colección (default: "students")

## Dependencias

- Go 1.19+
- MongoDB
- Kubernetes 1.19+
- Ingress NGINX Controller

## Consideraciones de Seguridad

1. Validación de formato de ID
2. Manejo seguro de errores
3. Sanitización de parámetros
4. Limitación de información sensible en respuestas

## Monitoreo y Logs

- Endpoint de health check: `/health`
- Logs en formato JSON
- Métricas de rendimiento:
  - Tiempo de respuesta
  - Tasa de éxito/error
  - Latencia de búsqueda

## Solución de Problemas

1. Verificar la conexión con MongoDB
2. Comprobar los logs del pod
3. Validar la configuración del Ingress
4. Verificar el estado del servicio en Kubernetes
5. Revisar el formato de los IDs en las peticiones 