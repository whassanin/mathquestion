from datetime import date
from rest_framework import serializers
from mathquestion.models import *
from django.db.models import *

def precedence(op):
    if op == '+' or op == '-':
        return 1
    if op == '*' or op == '/':
        return 2
    return 0
    
def applyOp(a, b, op):
    if op == '+': return a + b
    if op == '-': return a - b
    if op == '*': return a * b
    if op == '/': return a / b
    
def calculate(tokens):
    values = []
    ops = []
    i = 0
    while i < len (tokens):
            
        if tokens[i] == ' ':
            i+=1
            continue
            
        elif tokens[i] == '(':
            ops.append(tokens[i])
            
        elif tokens[i].isdigit():
                
            val = 0
            j = i
            while (j < len(tokens) and tokens[j].isdigit()):
                val = (val * 10) + int(tokens[j])
                j += 1
            
            values.append(val)
            i = j
            i -= 1
            
        elif tokens[i] == ')':
            while len(ops) != 0 and ops[-1] != '(':
                val2 = values.pop()
                val1 = values.pop()
                op = ops.pop()
                r = applyOp(val1, val2, op)
                values.append(r)
                
            ops.pop()
            
        else:
            while (len(ops) != 0 and precedence(ops[-1]) >= precedence(tokens[i])):
                val2 = values.pop()
                val1 = values.pop()
                op = ops.pop()
                values.append(applyOp(val1, val2, op))
            ops.append(tokens[i])            
            
        i += 1

    while len(ops) != 0:
        val2 = values.pop()
        val1 = values.pop()
        op = ops.pop()
        r = applyOp(val1,val2,op)
        values.append(r)
            
    return values[-1]

class MathDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = MathData
        fields = [
            'id',
            'expression',
            'result',
            'responseTime',
            'isCalculated',
            'createdDate',
            'changedDate'
        ]

    def create(self,validated_data):
        expression = validated_data.get('expression')
        responseTime = validated_data.get('responseTime')
        result = calculate(expression)
        isCalculated = False
        createdDate = validated_data.get('createdDate')
        changedDate = validated_data.get('changedDate')
        mathData = MathData(expression=expression,result=result,isCalculated=isCalculated,createdDate=createdDate,changedDate=changedDate)
        mathData = MathData.objects.create(expression=expression,result=result,responseTime=responseTime,isCalculated=isCalculated,createdDate=createdDate,changedDate=changedDate)
        return mathData
    
    def update(self,instance,validated_data):
        expression = validated_data.get('expression')
        responseTime = validated_data.get('responseTime')
        result = calculate(expression)
        isCalculated = validated_data.get('isCalculated')
        createdDate = validated_data.get('createdDate')
        changedDate = validated_data.get('changedDate')
        instance.expression = expression
        instance.responseTime = responseTime
        instance.result = result
        instance.isCalculated = isCalculated  
        instance.createdDate = createdDate
        instance.changedDate = changedDate
        instance.save()
        return instance