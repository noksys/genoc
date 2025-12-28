{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Jupyter
    jupyter                   # Jupyter CLI
    python3Packages.jupyterlab # JupyterLab web UI
    python3Packages.notebook  # Classic Jupyter Notebook
    
    # Core Data Science
    python3Packages.pandas      # Dataframes
    python3Packages.numpy       # Numerical arrays
    python3Packages.scipy       # Scientific computing
    python3Packages.matplotlib  # Plotting
    python3Packages.scikit-learn # Machine learning
    
    # R
    R       # R language
    rstudio # RStudio IDE
  ];
}
