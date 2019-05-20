controladdin PDFViewer
{
    StartupScript = 'pdfViewer/js/startup.js';
    Scripts = 'pdfViewer/js/script.js';

    HorizontalStretch = true;
    HorizontalShrink = true;
    MinimumWidth = 250;

    event OnControlAddInReady();
    event OnPdfViewerReady();
    procedure InitializeControl(url: Text);
    procedure LoadDocument(data: JsonObject);
}