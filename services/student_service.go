package services

import (
    "example.com/students-getbyid-service/models"
    "example.com/students-getbyid-service/repositories"
)

type StudentServiceInterface interface {
    GetStudentByID(id string) (*models.Student, error)
}

type StudentService struct {
    repo *repositories.StudentRepository
}

func NewStudentService(repo *repositories.StudentRepository) *StudentService {
    return &StudentService{repo}
}

func (s *StudentService) GetStudentByID(id string) (*models.Student, error) {
    return s.repo.GetStudentByID(id)
}

