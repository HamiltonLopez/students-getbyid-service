package controllers

import (
    "encoding/json"
    "net/http"
    "github.com/gorilla/mux"
    "example.com/students-getbyid-service/services"
)

type StudentController struct {
    Service *services.StudentService
}

func NewStudentController(service *services.StudentService) *StudentController {
    return &StudentController{
        Service: service,
    }
}

func (c *StudentController) GetStudentByID(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    id := vars["id"]
    if id == "" {
        http.Error(w, "ID no proporcionado", http.StatusBadRequest)
        return
    }

    student, err := c.Service.GetStudentByID(id)
    if err != nil {
        http.Error(w, "Estudiante no encontrado", http.StatusNotFound)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "message": "Estudiante encontrado",
        "student": student,
    })
}

