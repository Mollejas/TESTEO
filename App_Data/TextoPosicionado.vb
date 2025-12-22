Imports iTextSharp.text.pdf.parser

Public Class TextoPosicionado
    Inherits LocationTextExtractionStrategy

    Public Items As New List(Of ItemTexto)

    Public Overrides Sub RenderText(renderInfo As TextRenderInfo)
        MyBase.RenderText(renderInfo)

        Dim p = renderInfo.GetBaseline().GetStartPoint()
        Items.Add(New ItemTexto With {
            .Texto = renderInfo.GetText(),
            .X = p(0),
            .Y = p(1)
        })
    End Sub
End Class
