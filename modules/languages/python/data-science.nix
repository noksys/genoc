{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Jupyter
    jupyter
    python3Packages.jupyterlab
    python3Packages.notebook
    
    # Core Data Science
    python3Packages.pandas
    python3Packages.numpy
    python3Packages.scipy
    python3Packages.matplotlib
    python3Packages.scikit-learn
    
    # R
    R
    rstudio
  ];
}