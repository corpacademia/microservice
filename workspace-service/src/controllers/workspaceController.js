const workspaceService = require('../services/worksapceServices');

const createWorkspace = async (req, res) => {
    try {
        const { name, description, type, createdAt, urls, user, org_id } = req.body;

        // Extract file paths from uploaded files
        const files = req.files ? req.files.map(file => file.path) : [];

        const workspaceData = {
            name,
            description,
            type,
            createdAt,
            filesArray: files.length > 0 ? files : null,
            urlsArray: urls && urls.length > 0 ? urls : null,
            user,
            org_id
        };

        const createdWorkspace = await workspaceService.createWorkspaceService(workspaceData);

        if (!createdWorkspace) {
            return res.status(400).json({ success: false, message: "Workspace Creation Failed" });
        }

        return res.status(200).json({
            success: true,
            message: "Workspace Created Successfully",
            data: createdWorkspace
        });

    } catch (error) {
        console.error("Error in createWorkspace:", error.message);
        return res.status(500).json({
            success: false,
            message: "Internal Server Error",
            error: error.message
        });
    }
};

const getWorkspaceOnUserId = async (req, res) => {
    try {
        const { id } = req.params;

        const workspaces = await workspaceService.getWorkspaceByUserIdService(id);

        if (workspaces.length === 0) {
            return res.status(400).json({
                success: false,
                message: "Workspace not found"
            });
        }

        return res.status(200).json({
            success: true,
            message: "Workspace Found",
            data: workspaces
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal Server Error",
            error: error.message
        });
    }
};

const getWorkspaceOnId = async (req, res) => {
    try {
        const { id } = req.params;

        const workspace = await workspaceService.getWorkspaceByIdService(id);

        if (!workspace) {
            return res.status(400).json({
                success: false,
                message: "Workspace not found"
            });
        }

        return res.status(200).json({
            success: true,
            message: "Workspace Found",
            data: workspace
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal Server Error",
            error: error.message
        });
    }
};

const getWorkspaceByOrgId = async (req,res)=>{
    try {
        const { org_id } = req.params;
        console.log('orgid',org_id)
        const workspaces = await workspaceService.getWorkspaceByOrgIdService(org_id);
        if (workspaces.length === 0) {
            return res.status(400).json({
                success: false,
                message: "Workspace not found"
            });
        }
        return res.status(200).json({
            success: true,
            message: "Workspace Found",
            data: workspaces
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal Server Error",
            error: error.message
    });
}
}
const editWorkspace = async (req, res) => {
    try {
        const { id } = req.params;
        const { name, description, type, urls } = req.body;
        const files = req.files.map(file => file.path); // Extract file paths

        // Ensure `urls` and `files` are properly formatted for PostgreSQL
        const filesArray = files.length > 0 ? files : null;
        const urlsArray = urls && urls.length > 0 ? urls : null;

        const updatedWorkspace = await workspaceService.editWorkspaceService(id, name, description, type, filesArray, urlsArray);

        if (!updatedWorkspace) {
            return res.status(400).json({
                success: false,
                message: "Workspace not found"
            });
        }

        return res.status(200).json({
            success: true,
            message: "Workspace Updated Successfully",
            data: updatedWorkspace
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal Server Error",
            error: error.message
        });
    }
};

const deleteFile = async (req, res) => {
    try {
        const { filePath } = req.body; // Get file path from request body

        const result = await workspaceService.deleteFileService(filePath);

        return res.status(result.success ? 200 : 404).json(result);
        
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal Server Error",
            error: error.message
        });
    }
};

const deleteWorkspaces = async (req, res) => {
    try {
        const { ids } = req.body;
        const result = await workspaceService.deleteWorkspacesService(ids);
        const status = result.success ? 200 : 404;
        
        return res.status(status).json(result);
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal Server Error",
            error: error.message
        });
    }
};

const workspaceCount = async (req, res) => {
    try {
        const { org_id } = req.params;
        const result = await workspaceService.getWorkspaceCountService(org_id);
        const status = result.success ? 200 : 404;

        return res.status(status).json(result);
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal Server Error",
            error: error.message
        });
    }
};

module.exports = {
    createWorkspace,
    getWorkspaceOnUserId,
    getWorkspaceOnId,
    editWorkspace,
    deleteFile,
    deleteWorkspaces,
    workspaceCount,
    getWorkspaceByOrgId,
}