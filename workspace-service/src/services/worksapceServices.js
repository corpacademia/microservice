const pool = require('../db/dbConfig');
const queries = require('./workspaceQueries');
const path = require('path');
const fs = require('fs');

const createWorkspaceService = async (workspaceData) => {
    const values = [
        workspaceData.name,
        workspaceData.description,
        workspaceData.type,
        workspaceData.createdAt,
        workspaceData.filesArray,
        workspaceData.urlsArray,
        workspaceData.user,
        workspaceData.org_id
    ];
    try {
        const response = await pool.query(queries.createWorkspace, values);
        return response.rows[0]; // Returning created workspace data
    } catch (error) {
        throw new Error(error.message);
    }
};

const getWorkspaceByUserIdService = async (userId) => {
    try {
        const response = await pool.query(queries.getWorkspaceByUserId, [userId]);
        return response.rows;
    } catch (error) {
        throw new Error(error.message);
    }
};

const getWorkspaceByOrgIdService = async (org_id) => {
    try {
        if(!org_id){
            throw new Error("Organization ID is required");
        }
        const response = await pool.query(queries.getWorkspaceByOrgId, [org_id]);
        return response.rows;
    } catch (error) {
        throw new Error(error.message);
    }
}

const getWorkspaceByIdService = async (workspaceId) => {
    try {
        const response = await pool.query(queries.getWorkspaceById, [workspaceId]);
        return response.rows[0]; // Returning single workspace object
    } catch (error) {
        throw new Error(error.message);
    }
};

const editWorkspaceService = async (id, name, description, type, filesArray, urlsArray) => {
    try {
        const response = await pool.query(queries.updateWorkspace, [
            name,
            description,
            type,
            filesArray,
            urlsArray,
            new Date().toISOString(),
            id
        ]);
        return response.rows[0]; // Returning updated workspace
    } catch (error) {
        throw new Error(error.message);
    }
};

const deleteFileService = async (filePath) => {
    try {
        if (!filePath) {
            throw new Error("File path is required");
        }

        // Resolve the absolute path to prevent directory traversal attacks
        const absolutePath = path.resolve(__dirname, '..', filePath);

        // Check if the file exists before deleting
        if (fs.existsSync(absolutePath)) {
            fs.unlinkSync(absolutePath); // Delete the file
            return { success: true, message: "File deleted successfully" };
        } else {
            throw new Error("File not found");
        }
    } catch (error) {
        throw new Error(error.message);
    }
};

const deleteWorkspacesService = async (ids) => {
    if (!Array.isArray(ids) || ids.length === 0) {
        throw new Error('Invalid input: IDs array is required');
    }

    try {
        const result = await pool.query(queries.deleteWorkspaces, [ids]);

        if (result.rowCount === 0) {
            return { success: false, message: 'No workspaces found to delete' };
        }

        return {
            success: true,
            message: 'Workspaces deleted successfully',
            deletedRecords: result.rows
        };
    } catch (error) {
        throw new Error(error.message);
    }
};

const getWorkspaceCountService = async (org_id) => {
    try {
        const result = await pool.query(queries.getWorkspaceCount, [org_id]);

        if (result.rowCount === 0) {
            return { success: false, message: 'No workspaces found' };
        }

        const count = parseInt(result.rows[0].count, 10);
        return { success: true, message: 'Workspace count fetched successfully', data: { count } };
    } catch (error) {
        throw new Error(error.message);
    }
};

module.exports = {
    createWorkspaceService,
    getWorkspaceByUserIdService,
    getWorkspaceByIdService,
    editWorkspaceService,
    deleteFileService,
    deleteWorkspacesService,
    getWorkspaceCountService,
    getWorkspaceByOrgIdService,
}