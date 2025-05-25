#!/bin/bash

# Colores para la salida
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# URLs de los servicios
SERVICE_URL="http://${KUBE_IP}:30083"
CREATE_URL="http://${KUBE_IP}:30081"

echo "Probando Students GetById Service..."
echo "==================================="

# Primero necesitamos crear un estudiante para obtener un ID válido
echo -e "\nCreando estudiante de prueba..."
response=$(curl -s -X POST \
  "${CREATE_URL}/students" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Estudiante Prueba",
    "age": 20,
    "email": "test@example.com"
  }')

if [[ $response == *"id"* ]]; then
    STUDENT_ID=$(echo $response | grep -o '"id":"[^"]*' | cut -d'"' -f4)
    echo "ID del estudiante creado: $STUDENT_ID"
else
    echo -e "${RED}No se pudo crear el estudiante de prueba${NC}"
    exit 1
fi

# Test 1: Obtener estudiante por ID válido
echo -e "\nTest 1: Obtener estudiante por ID válido"
response=$(curl -s -X GET "${SERVICE_URL}/students/${STUDENT_ID}")

if [[ $response == *"id"* && $response == *"Estudiante Prueba"* ]]; then
    echo -e "${GREEN}✓ Test 1 exitoso: Estudiante encontrado correctamente${NC}"
else
    echo -e "${RED}✗ Test 1 fallido: No se pudo obtener el estudiante${NC}"
    echo "Respuesta: $response"
fi

# Test 2: Intentar obtener estudiante con ID inválido
echo -e "\nTest 2: Obtener estudiante con ID inválido"
response=$(curl -s -X GET "${SERVICE_URL}/students/invalid-id")

if [[ $response == *"error"* ]]; then
    echo -e "${GREEN}✓ Test 2 exitoso: El servicio manejó correctamente el ID inválido${NC}"
else
    echo -e "${RED}✗ Test 2 fallido: El servicio no validó correctamente el ID inválido${NC}"
fi

# Test 3: Intentar obtener estudiante con ID que no existe
echo -e "\nTest 3: Obtener estudiante con ID inexistente"
response=$(curl -s -X GET "${SERVICE_URL}/students/507f1f77bcf86cd799439011")

if [[ $response == *"error"* && $response == *"not found"* ]]; then
    echo -e "${GREEN}✓ Test 3 exitoso: El servicio manejó correctamente el ID inexistente${NC}"
else
    echo -e "${RED}✗ Test 3 fallido: El servicio no manejó correctamente el ID inexistente${NC}"
fi

# Test 4: Verificar formato de respuesta
echo -e "\nTest 4: Verificar formato de respuesta"
response=$(curl -s -X GET "${SERVICE_URL}/students/${STUDENT_ID}")

if [[ $response == *"id"* && $response == *"name"* && $response == *"age"* && $response == *"email"* ]]; then
    echo -e "${GREEN}✓ Test 4 exitoso: El formato de respuesta es correcto${NC}"
else
    echo -e "${RED}✗ Test 4 fallido: El formato de respuesta no es el esperado${NC}"
fi

echo -e "\nPruebas completadas!"

# Limpiar: Eliminar el estudiante de prueba
echo -e "\nLimpiando datos de prueba..."
DELETE_URL="http://localhost:30085"
curl -s -X DELETE "${DELETE_URL}/students/${STUDENT_ID}" > /dev/null
echo "Estudiante de prueba eliminado" 