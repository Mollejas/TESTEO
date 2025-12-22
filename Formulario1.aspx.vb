' Formulario.aspx.vb
Imports System
Imports System.Web.UI
Imports PuppeteerSharp
Imports PuppeteerSharp.Media


Public Class Formulario1
    Inherits System.Web.UI.Page

    Protected Async Sub btnPdf_Click(sender As Object, e As EventArgs) Handles btnPdf.Click
        Try
            Dim html As String = hidHtml.Value
            If String.IsNullOrWhiteSpace(html) Then
                litMensaje.Text = "<div style='color:red'>No llegó contenido del formulario. Revisa que OnClientClick=snapshotForm() esté configurado.</div>"
                Return
            End If

            Dim storePath = Server.MapPath("~/App_Data/.local-chromium")
            Dim pdfPath = Server.MapPath("~/App_Data/Formulario_Inspeccion.pdf")

            ' Descargar Chromium recomendado (sin DefaultChromiumRevision)
            Dim fetcher = New BrowserFetcher(New BrowserFetcherOptions With {.Path = storePath})
            Dim installed = Await fetcher.DownloadAsync()
            Dim executablePath = installed.GetExecutablePath()

            Dim launch = New LaunchOptions With {
                .Headless = True,
                .executablePath = executablePath,
                .Args = New String() {"--no-sandbox", "--disable-gpu"}
            }

            Using browser = Await Puppeteer.LaunchAsync(launch)
                Using page = Await browser.NewPageAsync()

                    Await page.EmulateMediaTypeAsync(PuppeteerSharp.Media.MediaType.Print)

                    ' Cargar el HTML “horneado” con tus valores
                    Await page.SetContentAsync(html, New NavigationOptions With {
                        .WaitUntil = New WaitUntilNavigation() {WaitUntilNavigation.Networkidle2}
                    })

                    ' Esperar a que TODAS las imágenes terminen de cargar
                    Dim waitImgs = "
                        (async () => {
                          const imgs = Array.from(document.images);
                          await Promise.all(imgs.map(img => img.complete ? Promise.resolve() :
                              new Promise(res => { img.onload = img.onerror = res; })));
                          return true;
                        })()"
                    Await page.EvaluateFunctionAsync(waitImgs)

                    ' Generar PDF (honra @media print y @page)
                    Dim opt = New PdfOptions With {
                        .Format = PaperFormat.A4,
                        .MarginOptions = New MarginOptions With {.Top = "0in", .Right = "0in", .Bottom = "0in", .Left = "0in"},
                        .PrintBackground = True,
                        .PreferCSSPageSize = True
                    }
                    Await page.PdfAsync(pdfPath, opt)

                    ' Descargar al cliente
                    Response.Clear()
                    Response.ContentType = "application/pdf"
                    Response.AddHeader("Content-Disposition", "attachment; filename=Formulario_Inspeccion.pdf")
                    Response.TransmitFile(pdfPath)
                    Response.End()
                End Using
            End Using

        Catch ex As Threading.ThreadAbortException
            ' Ignora: lo lanza Response.End()
        Catch ex As Exception
            litMensaje.Text = "<div style='color:red'>Error al generar PDF: " &
                              Server.HtmlEncode(ex.Message) & "</div>"
        End Try
    End Sub
End Class