let project = new Project('Grafikha');

project.addLibrary('kha2d');
project.addLibrary('zui');
project.localLibraryPath = 'libs'
project.addLibrary("dconsole");

project.addSources('Sources');
project.addAssets('Assets/**');

resolve(project);
