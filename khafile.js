let project = new Project('Grafikha');

project.localLibraryPath = 'libs'
project.addLibrary('kha2d');
project.addLibrary("dconsole");

project.addSources('Sources');
project.addAssets('Assets/**');

resolve(project);
