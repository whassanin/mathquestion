from django.db import models

# Create your models here.

class MathData(models.Model):
    expression = models.CharField(max_length=500)
    result = models.FloatField()
    responseTime = models.IntegerField()
    isCalculated = models.BooleanField()
    createdDate = models.DateTimeField()
    changedDate = models.DateTimeField()

    def __str__(self):
        return str(self.id)