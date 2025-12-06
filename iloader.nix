{ lib
, appimageTools
, fetchurl
}:

let
  version = "1.1.4";
  pname = "iloader";
  src = fetchurl {
    url = "https://github.com/nab138/iloader/releases/download/v${version}/iloader-linux-amd64.AppImage";
    hash = "sha256-O/J4eFFt4UiOMM2yoEnHCU78zJw8i+5GRIH3VPkDPIc=";
  };

  appimageContents = appimageTools.extractType1 { name = pname; src = src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  postInstall = ''
    # Replace Exec=AppRun with the actual wrapped binary
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' "Exec=$out/bin/${pname}"
  '';

  meta = {
    description = "Viewer for electronic invoices";
    homepage = "https://github.com/nab138/iloader";
    downloadPage = "https://github.com/nab138/iloader/releases";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ onny ];
    platforms = [ "x86_64-linux" ];
  };
}
