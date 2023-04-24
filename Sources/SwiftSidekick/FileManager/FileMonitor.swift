import Foundation
import Combine

public class FileMonitor: ObservableObject {
    private let file: URL
    private var dir: URL { file.deletingLastPathComponent() }
    private var writeSource: DispatchSourceFileSystemObject?
    private var deleteSource: DispatchSourceFileSystemObject?
    private let eventSubject = PassthroughSubject<Events, Never>()
    public var eventPublisher: AnyPublisher<Events, Never> { .init(eventSubject) }
    @Published public private(set) var fileExsists: Bool = false
    
    public init(_ file: URL) {
        self.file = file
        createDirector()
        checkFile()
        monitor()
    }
}
public extension FileMonitor {
    enum Events {
        case write
        case delete
    }
}
private extension FileMonitor {
    func monitor() {
        writeSource = createSource(.write) { event in
            self.checkFile()
            if self.fileExsists { self.eventSubject.send(.write) }
        }
        deleteSource = createSource(.delete) { event in
            self.checkFile()
            if self.fileExsists == false { self.eventSubject.send(.delete) }
        }
    }
    func createSource(
        _ watch: DispatchSource.FileSystemEvent,
        event: @escaping (DispatchSource.FileSystemEvent) -> ()) -> DispatchSourceFileSystemObject? {
        let path = dir.path
        let descriptor = open(path, O_EVTONLY)
        if descriptor < 0 { return nil }
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: descriptor,
            eventMask: [watch],
            queue: .main)
        source.setEventHandler {
            event(watch)
        }
        source.setCancelHandler {
            close(descriptor)
        }
        source.resume()
        return source
    }
    func createDirector() {
        switch FileManager.default.exsists(at: dir) {
        case .isDirectory, .isFile: break
        case .doesNotExsist: try? FileManager.default.createDirectory(from: dir)
        }
    }
    func checkFile() {
        switch FileManager.default.exsists(at: file) {
        case .doesNotExsist: fileExsists = false
        case .isDirectory, .isFile: fileExsists = true
        }
    }
}
