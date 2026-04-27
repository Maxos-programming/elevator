import { isEnvBrowser } from "./misc"

export async function fetchNui<T = unknown>(
  eventName: string,
  data?: unknown,
  mockData?: T,
): Promise<T> {
  const options = {
    method: "post",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify(data),
  };

  if (isEnvBrowser() && mockData) return mockData

  const resourceName = (window as any).GetParentResourceName
    ? (window as any).GetParentResourceName() : "nui-frame-app"

  const resp = await fetch(`https://${resourceName}/${eventName}`, options).catch(() => {
    throw new Error(`[fetchNui] Failed to reach NUI endpoint: ${eventName}`)
  })

  if (!resp.ok) {
    throw new Error(`[fetchNui] Bad response for ${eventName}: ${resp.status}`)
  }

  return resp.json()
}
