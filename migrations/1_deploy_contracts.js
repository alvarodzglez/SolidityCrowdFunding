const CrowdFunding = artifacts.require("CrowdFunding");

module.exports = function(deployer) {
  // Define los parámetros que se pasarán al constructor
  const projectId = "1";
  const projectName = "Project Name";
  const projectDescription = "This is a project description.";
  const fundraisingGoal = 1000; // Ajusta este valor según tus necesidades

  // Despliega el contrato con los parámetros necesarios
  deployer.deploy(CrowdFunding, projectId, projectName, projectDescription, fundraisingGoal);
};
