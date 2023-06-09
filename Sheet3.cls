VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Sub stocks()

    ' declare vars
    Dim i As Double
    Dim j As Integer
    Dim total_volume As Double
    Dim vol As Double
    
    ' open price for the first row
    ' closing price for the last row
    Dim openPrice As Double
    Dim closePrice As Double
    Dim yearlyChange As Double
    Dim percentChange As Double
    
    Dim currStock As String
    Dim nextStock As String
    
    Dim summaryRow As Double
    
    ' summary of the summary table
    Dim greatestIncrease As Double
    Dim greatestIncreaseStock As String
    
    Dim greatestDecrease As Double
    Dim greatestDecreaseStock As String
    
    Dim greatestVolume As Double
    Dim greatestVolumeStock As String
    
    Dim ws As Worksheet
    
    For Each ws In ThisWorkbook.Worksheets
    
        ' assign
        total_volume = 0
        summaryRow = 2
        openPrice = ws.Cells(2, 3).Value
        
        ' default for comparison
        greatestIncrease = -9999999999#
        greatestDecrease = 99999999999#
        greatestVolume = -9999999999#
        
        ' column headers
        ws.Cells(1, 10).Value = "Ticker"
        ws.Cells(1, 11).Value = "Yearly Change"
        ws.Cells(1, 12).Value = "Percent Change"
        ws.Cells(1, 13).Value = "Total Volume"
        
        'do work
        For i = 2 To 22771
        
            currStock = ws.Cells(i, 1).Value
            nextStock = ws.Cells(i + 1, 1).Value
            
            ' add to total
            vol = ws.Cells(i, 7).Value
            total_volume = total_volume + vol
        
            If currStock <> nextStock Then
                ' get the closing price
                closePrice = ws.Cells(i, 6).Value
                yearlyChange = closePrice - openPrice
                
                ' Error Handling
                If openPrice = 0 Then
                    percentChange = 0
                Else
                    percentChange = yearlyChange / openPrice
                End If
            
                ' write the output
                ws.Cells(summaryRow, 10).Value = currStock
                ws.Cells(summaryRow, 11).Value = yearlyChange
                ws.Cells(summaryRow, 12).Value = percentChange
                ws.Cells(summaryRow, 12).NumberFormat = "0.00%" ' make a percent
                ws.Cells(summaryRow, 13).Value = total_volume
                
                ' conditional formatting
                If yearlyChange < 0 Then
                    ws.Cells(summaryRow, 11).Interior.ColorIndex = 3
                Else
                    ws.Cells(summaryRow, 11).Interior.ColorIndex = 4
                End If
                
                ' reset
                total_volume = 0
                openPrice = ws.Cells(i + 1, 3).Value
                
                ' increment the summary table row
                summaryRow = summaryRow + 1
            End If
        Next i
        
        For j = 2 To summaryRow
            
            If ws.Cells(j, 12).Value > greatestIncrease Then
                ' hooray, we have a bigger increase in percent change
                greatestIncrease = ws.Cells(j, 12).Value
                greatestIncreaseStock = ws.Cells(j, 10).Value
            End If
            
            If ws.Cells(j, 12).Value < greatestDecrease Then
                ' hooray, we have a smaller percent change
                greatestDecrease = ws.Cells(j, 12).Value
                greatestDecreaseStock = ws.Cells(j, 10).Value
            End If
            
            If ws.Cells(j, 13).Value > greatestVolume Then
                ' hooray, we have a bigger increase in percent change
                greatestVolume = ws.Cells(j, 13).Value
                greatestVolumeStock = ws.Cells(j, 10).Value
            End If
            
        Next j
        
        ' we're done
        ws.Cells(1, 16).Value = "Ticker"
        ws.Cells(1, 17).Value = "Value"
        ws.Cells(2, 15).Value = "Greatest % Increase"
        ws.Cells(2, 16).Value = greatestIncreaseStock
        ws.Cells(2, 17).Value = greatestIncrease
        ws.Cells(2, 17).NumberFormat = "0.00%" ' make a percent
        
        ws.Cells(3, 15).Value = "Greatest % Decrease"
        ws.Cells(3, 16).Value = greatestDecreaseStock
        ws.Cells(3, 17).Value = greatestDecrease
        ws.Cells(3, 17).NumberFormat = "0.00%" ' make a percent
        
        ws.Cells(4, 15).Value = "Greatest Total Volume"
        ws.Cells(4, 16).Value = greatestVolumeStock
        ws.Cells(4, 17).Value = greatestVolume
    
    Next ws
End Sub
